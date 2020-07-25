//
//  ECApiDataPluginExtentions.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/25.
//

import UIKit
import Moya

extension ECResponseApiType {
    ///请求接口并传入数据插件
    public func request(callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none, plugins: ECDataPlugin<ResponseType>... , completion: @escaping (Swift.Result<ResponseType, Error>) -> Void) {
        let provider = self.asDataProvider(callbackQueue: callbackQueue, progress: progress)
        let plugin = ECDataPluginDecorator<DataProvider>()
        plugin.dataProvider = provider
        plugin.plugins = plugins
        //内部变量手动retain
        plugin.easy.retain()
        plugin.easyData { (result) in
            completion(result)
            plugin.easy.release()
        }
    }
}

extension ECViewControllerType {
    ///请求接口，使用该方式会在源视图上显示loading和失败时弹toast，若要自己定制数据插件或者都静默请求，请直接调用api.request相关方法
    public func request<ApiType: ECResponseApiType>(_ api: ApiType, callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none, completion: @escaping (Swift.Result<ApiType.ResponseType, Error>) -> Void) {
        let provider = api.asDataProvider(callbackQueue: callbackQueue, progress: progress)
        let decorator = ECViewDataOutsideDecorator<ApiType.DataProvider>()
        decorator.targetView = self.view
        decorator.dataProvider = provider
        //内部变量手动retain
        decorator.easy.retain()
        decorator.easyData { (result) in
            completion(result)
            decorator.easy.release()
        }
    }
}
extension ECViewControllerCondition {
    ///请求接口，使用该方式会在源视图上显示loading和失败时弹toast，若要自己定制数据插件或者都静默请求，请直接调用api.request相关方法
    public func request<ApiType: ECResponseApiType>(_ api: ApiType, callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none, completion: @escaping (Swift.Result<ApiType.ResponseType, Error>) -> Void) {
        let provider = api.asDataProvider(callbackQueue: callbackQueue, progress: progress)
        let decorator = ECViewDataOutsideDecorator<ApiType.DataProvider>()
        decorator.targetView = self.source?.view
        decorator.dataProvider = provider
        //内部变量手动retain
        decorator.easy.retain()
        decorator.easyData { (result) in
            completion(result)
            decorator.easy.release()
        }
    }
}
