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
public struct ECApiDataProvider<ApiType: ECResponseApiType>: ECDataProviderType {
    public typealias DataType = ApiType.ResponseType
    
    public let api: ApiType
    public let scheme: ECApiRequestSchemeType
    public init(api: ApiType, scheme: ECApiRequestSchemeType) {
        self.api = api
        self.scheme = scheme
    }
    
    public func easyData(completion: @escaping (Result<ApiType.ResponseType, Error>) -> Void) {
        self.scheme.request(self.api).success { data in
            completion(.success(data))
        }.failure { error in
            completion(.failure(error))
        }
    }
}
extension ECResponseApiType {
    public func dataProvider(for scheme: ECApiRequestSchemeType) -> ECApiDataProvider<Self> {
        return ECApiDataProvider<Self>(api: self, scheme: scheme)
    }
}
