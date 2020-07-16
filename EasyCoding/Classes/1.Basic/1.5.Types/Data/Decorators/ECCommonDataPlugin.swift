//
//  ECCommonDataPlugin.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/6.
//

import UIKit

///只针对结果做插件
public class ECDataResultPlugin<DataType>: ECDataPlugin<DataType> {
    public var success: ((DataType) -> Void)?
    public var failure: ((Error) -> Void)?
    public override func didResponse(for provider: Any, result: Result<DataType, Error>, completion: @escaping (Result<DataType, Error>) -> Void) {
        super.didResponse(for: provider, result: result, completion: completion)
        switch result {
        case let .success(data):
            self.success?(data)
        case let .failure(error):
            self.failure?(error)
        }
    }
}
extension ECDataPlugin {
    public static func result(success: ( (DataType)-> Void)? = nil, failure: ( (Error) -> Void)? = nil) -> ECDataResultPlugin<DataType> {
        let plugin = ECDataResultPlugin<DataType>()
        plugin.success = success
        plugin.failure = failure
        return plugin
    }
}

///简单的打印日志
open class ECDataLogPlugin<DataType>: ECDataPlugin<DataType> {
    #if DEBUG
    /* 开始请求不写
    open override func didRequest(for provider: Any) {
        print("开始请求: \(provider)")
    }*/
    open override func didResponse(for provider: Any, result: Result<DataType, Error>, completion: @escaping (Result<DataType, Error>) -> Void) {
        switch result {
        case let .success(data):
            print("请求成功: \(provider) \n结果：\(data)")
        case let .failure(error):
            print("请求失败: \(provider) \n原因：\(error.localizedDescription)")
        }
    }
    #endif
}

extension ECDataPlugin {
    public static func log() -> ECDataLogPlugin<DataType> {
        let plugin = ECDataLogPlugin<DataType>()
        return plugin
    }
}
