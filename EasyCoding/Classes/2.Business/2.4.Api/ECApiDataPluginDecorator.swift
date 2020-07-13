//
//  ECApiDataPluginDecorator.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/13.
//

import UIKit
import HandyJSON
import Moya
import Result

open class ECApiDataPluginDecorator<ApiType: ECResponseApiType>: ECDataPluginDecorator<ApiType> {
    open var manager: ECApiManagerType?
    
    open func request(original completion: @escaping (Result<ApiType.DataType, Error>) -> Void, injected injectedCompletion: @escaping (Result<ApiType.DataType, Error>) -> Void) {
        if let api = self.dataProvider {
            (self.manager ?? api.defaultManager).request(api).success { data in
                injectedCompletion(.success(data))
            }.failure { error in
                injectedCompletion(.failure(error))
            }
        }
    }
}
extension ECResponseApiType {
    ///提供简短的类型声明，解决泛型使用时声明太长的问题
    public typealias DataPlugin = ECApiDataPluginDecorator<Self>
    ///添加插件
    public func dataPlugin(manager: ECApiManagerType? = nil , _ plugins: ECDataPlugin<ResponseType>...) -> DataPlugin {
        let decorator = ECApiDataPluginDecorator<Self>()
        decorator.plugins = plugins
        return decorator
    }
}
