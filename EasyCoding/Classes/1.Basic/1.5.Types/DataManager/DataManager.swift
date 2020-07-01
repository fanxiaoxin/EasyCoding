//
//  DataProvider.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/1.
//

import UIKit

///数据管理，可管理插件
open class ECDataManager<DataProviderType: ECDataProviderType>: ECDataManagerPlugin<DataProviderType.DataType>, ECDataProviderDecoratorType, ECDataManagerPluginDelegate {
    public typealias DataType = DataProviderType.DataType
    ///原始的数据提供者
    open var dataProvider: DataProviderType?
    override var delegate: ECDataManagerPluginDelegate? {
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
    /*
    internal func reloadData(for plugin: Any) {
        if let provider = self.dataProvider, let pi = plugin as? ECDataManagerPlugin<DataType>, let completion = self.lastCompletion {
            if pi.willRequest() {
                provider.easyData { [weak pi] (result) in
                    if pi?.willResponse(for: result, completion: completion) ?? true {
                        completion(result)
                        pi?.didResponse(for: result, completion: completion)
                    }
                }
                pi.didRequest()
            }
        }
    }*/
}
