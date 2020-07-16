//
//  ECDataControlType.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/13.
//

import UIKit

public protocol ECDataControlType {
    associatedtype DataPluginType: ECDataProviderDecoratorType
    ///数据插件
    var dataPlugin: DataPluginType  { get }
}
extension ECDataControlType {
    ///数据源
    public var dataProvider: DataPluginType.DataProviderType? {
        get {
            return self.dataPlugin.dataProvider
        }
        set {
            self.dataPlugin.dataProvider = newValue
        }
    }
}

public protocol ECDataScrollViewType: UIScrollView {
    associatedtype DataProviderType: ECDataProviderType
    ///数据插件
    var dataPlugin: ECDataPluginDecorator<DataProviderType>?  { get set }
}
extension ECDataScrollViewType {
    ///数据源
    public var dataProvider: DataProviderType? {
        get {
            return self.dataPlugin?.dataProvider
        }
        set {
            if self.dataPlugin == nil {
                let p = ECViewDataRefreshDecorator<DataProviderType>()
                p.targetView = self
                self.dataPlugin = p
            }
            self.dataPlugin?.dataProvider = newValue
        }
    }
}
extension ECDataScrollViewType where DataProviderType: ECDataPagedProviderType {
    ///数据源
    public var dataProvider: DataProviderType? {
        get {
            return self.dataPlugin?.dataProvider
        }
        set {
            if self.dataPlugin == nil {
                let p = ECViewDataPagedDecorator<DataProviderType>()
                p.targetView = self
                self.dataPlugin = p
            }
            self.dataPlugin?.dataProvider = newValue
        }
    }
}
