//
//  ApiAccessable.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/11/26.
//

import UIKit
import Moya
import HandyJSON

public protocol ECApiRequestable {
    var defaultScheme: ECApiRequestSchemeType { get }
}
extension ECApiRequestable {
    ///调用接口
    @discardableResult
    public func request<ApiType: ECResponseApiType>(_ api: ApiType, scheme: ECApiRequestSchemeType? = nil, completion: ((ApiType.ResponseType) -> Void)? = nil) -> ECApiResultHandling<ApiType.ResponseType> {
        let handler = (scheme ?? self.defaultScheme).request(api)
        if let c = completion {
            handler.success(c)
        }
        return handler
    }
}
