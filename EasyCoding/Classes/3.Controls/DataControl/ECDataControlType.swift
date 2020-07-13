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
public protocol ECDataScrollViewType: ECDataControlType where Self: UIScrollView, DataPluginType == ECDataPluginDecorator<DataProviderType> {
    associatedtype DataProviderType: ECDataProviderType
    func createDataPlugin() -> DataPluginType
}
extension ECDataScrollViewType {
    public typealias DataPluginType = ECDataPluginDecorator<DataProviderType>
    public func createDataPlugin() -> DataPluginType {
        let p = ECViewDataRefreshDecorator<DataProviderType>()
        p.targetView = self
        return p
    }
}
extension ECDataScrollViewType where DataProviderType: ECDataPagedProviderType {
    public func createDataPlugin() -> DataPluginType {
        let p = ECViewDataPagedDecorator<DataProviderType>()
        p.targetView = self
        return p
    }
}

