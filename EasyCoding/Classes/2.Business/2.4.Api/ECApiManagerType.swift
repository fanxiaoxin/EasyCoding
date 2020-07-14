//
//  ECApiManager.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/14.
//

import UIKit
import Moya

//负责Api整体相关管理工作
public protocol ECApiManagerType {
    ///格式化请求参数，可附加通用参数等操作
    func format(paramaters: [String: Any]?) -> [String:Any]?
    ///生成MoyaProvider
    func provider<ApiType: ECApiType>(for api: ApiType) -> MoyaProvider<ApiType>
}

public struct ECApiManager: ECApiManagerType {
    ///格式化请求参数，可附加通用参数等操作
    public func format(paramaters: [String: Any]?) -> [String:Any]? {
        return paramaters
    }
    ///生成MoyaProvider
    public func provider<ApiType: ECApiType>(for api: ApiType) -> MoyaProvider<ApiType> {
        return MoyaProvider<ApiType>()
    }
}
