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
    
}
extension ECApiRequestable {
    ///调用接口
    @discardableResult
    public func request<ApiType: ECResponseApiType>(_ api: ApiType, completion: ((ApiType.ResponseType) -> Void)? = nil) -> ECApiResultHandling<ApiType.ResponseType> {
        return self.request(api, manager: api.defaultManager, completion: completion)
    }
    ///调用接口
    @discardableResult
    public func request<ApiType: ECResponseApiType>(_ api: ApiType, manager: ECApiManagerType?, callbackQueue: DispatchQueue? = nil, progress: ProgressBlock? = nil, completion: ((ApiType.ResponseType) -> Void)? = nil) -> ECApiResultHandling<ApiType.ResponseType> {
        let handler = (manager ?? api.defaultManager).request(api, callbackQueue: callbackQueue, progress: progress)
        if let c = completion {
            handler.success(c)
        }
        return handler
    }
}
