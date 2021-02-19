//
//  EasyApiDataPluginDecorator.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/13.
//

import UIKit
import HandyJSON
import Moya

///Api和EasyData的适配器
open class EasyApiDataProvider<ApiType: EasyResponseApiType>: EasyDataProviderType {
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
extension EasyApiDataProvider: EasyDataListProviderType where ApiType: EasyListResponseApiType {
    public typealias SectionType = EasyNull
    
    public typealias ModelType = ApiType.ResponseType.ModelType
    
    public func list(for data: ApiType.ResponseType) -> [ApiType.ResponseType.ModelType] {
        return data.list ?? []
    }
}
///分页列表
extension EasyApiDataProvider: EasyDataPagedProviderType where ApiType: EasyPagedResponseApiType {
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

// MARK: Api转换为EasyDataProviderType

extension EasyResponseApiType {
    public typealias DataProvider = EasyApiDataProvider<Self>
    ///将Api转换为EasyDataProviderType
    public func asDataProvider(callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none) -> EasyApiDataProvider<Self> {
        let provider = EasyApiDataProvider<Self>(api: self)
        provider.callbackQueue = callbackQueue
        provider.progress = progress
        return provider
    }
}
