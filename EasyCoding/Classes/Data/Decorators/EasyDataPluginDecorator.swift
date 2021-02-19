//
//  DataProvider.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/1.
//

import UIKit

internal protocol EasyDataPluginDelegate: class {
//    func reloadData(for plugin: Any)
    func reloadData()
}
///EasyDataManager需要使用的插件，使用空类是为了申明时可用，直接协议无法编码
open class EasyDataPlugin<DataType>: EasyDataProviderInjectable {
    ///是否激活
    open var isActivated: (() -> Bool) = { true }
    ///是否正在激活，防止请求前和请求后的值不一样
    private var _isActivating: Bool = false
    ///是否正在激活，防止请求前和请求后的值不一样
    open var isActivating: Bool {
        get {
            if self.rejudgeActivatedEveryTime {
                return self.isActivated()
            }else{
                return _isActivating
            }
        }
        set {
            _isActivating = newValue
        }
    }
    ///每次都重新判断是否激活，若设为否则在willRequest时缓存激活状态，否则每次都调用isActivated进行判断
    open var rejudgeActivatedEveryTime = false
    ///插件可以包含子插件
    open var plugins: [EasyDataPlugin<DataType>] = [] {
        didSet {
            for p in plugins {
                p.delegate = self.delegate
            }
        }
    }
    ///最后一次请求操作
    public var lastCompletion: ((Result<DataType, Error>) -> Void)? {
        didSet {
            for p in plugins {
                p.lastCompletion = self.lastCompletion
            }
        }
    }

    internal weak var delegate: EasyDataPluginDelegate? {
        didSet {
            for p in plugins {
                p.delegate = self.delegate
            }
        }
    }
    
    public init() {}
    
    ///设置是否激活
    open func activate(_ activate: Bool) {
        self.isActivated = { activate }
    }
    ///设置是否激活
    open func activate(_ activate: @escaping () -> Bool) {
        self.isActivated = activate
    }

    public func reloadData() {
        self.delegate?.reloadData()
//        self.delegate?.reloadData(for: self)
    }
    
    open func willRequest(for provider: Any) -> Bool {
        for p in self.plugins {
            p.isActivating = p.isActivated()
            if p.isActivating && !p.willRequest(for: provider) {
                return false
            }
        }
        return true
    }
    open func didRequest(for provider: Any) {
        for p in self.plugins {
            if p.isActivating {
                p.didRequest(for: provider)
            }
        }
    }
    open func willResponse(for provider: Any, result: Result<DataType, Error>, completion: @escaping (Result<DataType, Error>) -> Void) -> Result<DataType, Error>? {
        var newResult = result
        for p in self.plugins.reversed() {
            if p.isActivating {
                guard let r = p.willResponse(for:provider, result: newResult, completion: completion) else {
                    return nil
                }
                newResult = r
            }
        }
        return newResult
    }
    open func didResponse(for provider: Any, result: Result<DataType, Error>, completion: @escaping (Result<DataType, Error>) -> Void) {
        for p in self.plugins.reversed() {
            if p.isActivating {
                p.didResponse(for:provider, result: result, completion: completion)
            }
        }
    }
}

///可添加插件的装饰器，用于不特定Provider的操作不用包太多层类型
open class EasyDataPluginDecorator<DataProviderType: EasyDataProviderType>: EasyDataPlugin<DataProviderType.DataType>, EasyDataProviderDecoratorType, EasyDataPluginDelegate {
    public typealias DataType = DataProviderType.DataType
    ///原始的数据提供者
    open var dataProvider: DataProviderType? {
        didSet {
            self.syncPluginDataProvider()
        }
    }
    open override var plugins: [EasyDataPlugin<DataProviderType.DataType>] {
        didSet {
            self.syncPluginDataProvider()
        }
    }
    override var delegate: EasyDataPluginDelegate? {
        get {
            return self
        }
        set {
            
        }
    }
    public override func reloadData() {
        if let completion = self.lastCompletion {
            self.easyData(completion: completion)
        }
    }
    //同步插件的数据提供
    open func syncPluginDataProvider() {
        if let provder = self.dataProvider {
            self.plugins.compactMap({ $0 as? EasyDataPluginDecorator<DataProviderType> }).forEach { (plugin) in
                plugin.dataProvider = provder
            }
        }
    }
}

extension EasyDataPluginDecorator: EasyDataPagedProviderType where DataProviderType: EasyDataPagedProviderType {
    
}

extension EasyDataPluginDecorator: EasyDataListProviderType where DataProviderType: EasyDataListProviderType {
    public typealias SectionType = DataProviderType.SectionType
    public typealias ModelType = DataProviderType.ModelType
}


extension EasyDataProviderType {
    public typealias Plugin = EasyDataPluginDecorator<Self>
    ///使用插件装饰器
    public func plugin(_ plugins: EasyDataPlugin<DataType>...) -> EasyDataPluginDecorator<Self> {
        let plugin = EasyDataPluginDecorator<Self>()
        plugin.dataProvider = self
        plugin.plugins = plugins
        return plugin
    }
}
