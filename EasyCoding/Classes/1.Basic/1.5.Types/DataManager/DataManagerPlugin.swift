//
//  ECDataManagerPlugin.swift
//  Alamofire
//
//  Created by JY_NEW on 2020/7/1.
//

import UIKit

internal protocol ECDataManagerPluginDelegate: class {
//    func reloadData(for plugin: Any)
    func reloadData()
}
///ECDataManager需要使用的插件，使用空类是为了申明时可用，直接协议无法编码
open class ECDataManagerPlugin<DataType>: ECDataProviderInjectable {
    ///是否激活
    open var isActivated: (() -> Bool) = { true }
    ///是否正在激活，防止请求前和请求后的值不一样
    open var isActivating: Bool = false
    ///插件可以包含子插件
    open var plugins: [ECDataManagerPlugin<DataType>] = [] {
        didSet {
            for p in plugins {
                p.delegate = self.delegate
            }
        }
    }
    ///最后一次请求操作
    public var lastCompletion: ((Result<DataType, Error>) -> Void)?

    internal weak var delegate: ECDataManagerPluginDelegate? {
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
    
    open func willRequest() -> Bool {
        for p in self.plugins {
            p.isActivating = p.isActivated()
            if p.isActivating && !p.willRequest() {
                return false
            }
        }
        return true
    }
    open func didRequest() {
        for p in self.plugins {
            if p.isActivating {
                p.didRequest()
            }
        }
    }
    open func willResponse(for result: Result<DataType, Error>, completion: @escaping (Result<DataType, Error>) -> Void) -> Bool {
        for p in self.plugins.reversed() {
            if p.isActivating && !p.willResponse(for: result, completion: completion) {
                return false
            }
        }
        return true
    }
    open func didResponse(for result: Result<DataType, Error>, completion: @escaping (Result<DataType, Error>) -> Void) {
        for p in self.plugins.reversed() {
            if p.isActivating {
                p.didResponse(for: result, completion: completion)
            }
        }
    }
}
