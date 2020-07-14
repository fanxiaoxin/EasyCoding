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
    open var callbackQueue: DispatchQueue? = .none
    open var progress: ProgressBlock? = .none
    open func request(original completion: @escaping (Result<ApiType.DataType, Error>) -> Void, injected injectedCompletion: @escaping (Result<ApiType.DataType, Error>) -> Void) {
        if let api = self.dataProvider {
            api.request(callbackQueue: self.callbackQueue, progress: self.progress) { (result) in
                switch result {
                case let .success(response): injectedCompletion(.success(response))
                case let .failure(error): injectedCompletion(.failure(error))
                }
            }
        }
    } 
}
extension ECResponseApiType {
    ///提供简短的类型声明，解决泛型使用时声明太长的问题
    public typealias DataPlugin = ECApiDataPluginDecorator<Self>
    ///添加插件
    public func dataPlugin(callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none, _ plugins: ECDataPlugin<ResponseType>...) -> DataPlugin {
        let decorator = ECApiDataPluginDecorator<Self>()
        decorator.callbackQueue = callbackQueue
        decorator.progress = progress
        decorator.plugins = plugins
        return decorator
    }
}
