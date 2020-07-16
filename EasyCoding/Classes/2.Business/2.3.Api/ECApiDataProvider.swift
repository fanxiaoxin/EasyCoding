//
//  ECApiDataPluginDecorator.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/13.
//

import UIKit
import HandyJSON
import Moya

///Api和ECData的适配器
open class ECApiDataProvider<ApiType: ECResponseApiType>: ECDataProviderType {
    public typealias DataType = ApiType.ResponseType
    
    public var api: ApiType
    
    open var callbackQueue: DispatchQueue? = .none
    open var progress: ProgressBlock? = .none
    
    public init(api: ApiType) {
        self.api = api
    }
    
    public func easyData(completion: @escaping (Result<ApiType.ResponseType, Error>) -> Void) {
        self.api.request(callbackQueue: .none, progress: .none, completion: completion)
    }
}
///列表
extension ECApiDataProvider: ECDataListProviderType where ApiType: ECListResponseApiType {
    public typealias SectionType = ECNull
    
    public typealias ModelType = ApiType.ResponseType.ModelType
    
    public func list(for data: ApiType.ResponseType) -> [ApiType.ResponseType.ModelType] {
        return data.list ?? []
    }
}
///分页列表
extension ECApiDataProvider: ECDataPagedProviderType where ApiType: ECPagedResponseApiType {
    public var page: Int {
        get {
            return self.api.page
        }
        set {
            self.api.page = newValue
        }
    }
    
    public func isLastPage(for data: DataType) -> Bool {
        return data.isEnd(for: self.api)
    }
    public func merge(data1: DataType, data2: DataType) -> DataType {
        return data1.merge(data: data2)
    }
}

// MARK: Api转换为ECDataProviderType

extension ECResponseApiType {
    public typealias DataProvider = ECApiDataProvider<Self>
    ///将Api转换为ECDataProviderType
    public func asDataProvider(callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none) -> ECApiDataProvider<Self> {
        let provider = ECApiDataProvider<Self>(api: self)
        provider.callbackQueue = callbackQueue
        provider.progress = progress
        return provider
    }
}
