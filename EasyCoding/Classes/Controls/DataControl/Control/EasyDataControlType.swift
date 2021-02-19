//
//  EasyDataControlType.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/13.
//

#if EASY_DATA

import UIKit

public protocol EasyDataControlType {
    associatedtype DataPluginType: EasyDataProviderDecoratorType
    ///数据插件
    var dataPlugin: DataPluginType  { get }
}
extension EasyDataControlType {
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

public protocol EasyDataScrollViewType: UIScrollView {
    associatedtype DataProviderType: EasyDataProviderType
    ///数据插件
    var dataPlugin: EasyDataPluginDecorator<DataProviderType>?  { get set }
}
extension EasyDataScrollViewType {
    ///数据源
    public var dataProvider: DataProviderType? {
        get {
            return self.dataPlugin?.dataProvider
        }
        set {
            if self.dataPlugin == nil {
                let p = EasyViewDataRefreshDecorator<DataProviderType>()
                p.targetView = self
                self.dataPlugin = p
            }
            self.dataPlugin?.dataProvider = newValue
        }
    }
}
extension EasyDataScrollViewType where DataProviderType: EasyDataPagedProviderType {
    ///数据源
    public var dataProvider: DataProviderType? {
        get {
            return self.dataPlugin?.dataProvider
        }
        set {
            if self.dataPlugin == nil {
                let p = EasyViewDataPagedDecorator<DataProviderType>()
                p.targetView = self
                self.dataPlugin = p
            }
            self.dataPlugin?.dataProvider = newValue
        }
    }
}

#endif
