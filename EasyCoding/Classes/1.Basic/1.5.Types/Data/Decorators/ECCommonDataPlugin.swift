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
    public override func didResponse(for result: Result<DataType, Error>, completion: @escaping (Result<DataType, Error>) -> Void) {
        super.didResponse(for: result, completion: completion)
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
