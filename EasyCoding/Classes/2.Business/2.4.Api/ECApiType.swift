//
//  ApiModuleType.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/6/5.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import UIKit
import Moya
import HandyJSON
import Alamofire

// MARK: 接口基础设置

///一个接口一个类
public protocol ECApiType: TargetType, HandyJSON, CustomStringConvertible {
    var parameters: [String: Any]? { get }
    ///是否将参数放于Body中否则放URL，默认GET放URL，其他放Body
    var isBodyParamters: Bool { get }
    ///该接口使用的MoyaProvider，默认无参，可根据情况自定义或设为属性可动态改变
    var manager: ECApiManagerType { get }
}
///配置默认值
extension ECApiType {
    public var method: Moya.Method { return .get }
    public var sampleData: Data { return "empty sample data".data(using: .utf8)! }
    public var headers: [String: String]? { return ["Content-type": "application/json"] }
    public var parameters: [String: Any]? { return self.toJSON() }
    
    public func finalParameters() -> [String: Any]? {
        return self.manager.format(paramaters: self.parameters)
    }
    public var isBodyParamters: Bool { return self.method == .get ? false : true }
    ///默认provider
    public var manager: ECApiManagerType { return ECApiManager() }
    ///默认get参数则放在URL，其他放在body
    public var task: Task {
        if let json = self.finalParameters() {
            if self.isBodyParamters {
                return .requestParameters(parameters: json, encoding: JSONEncoding.default)
            }else{
                return .requestParameters(parameters: json, encoding: URLEncoding.queryString)
            }
        }else{
            return .requestPlain
        }
    }

    public var description: String {
        return self.path + "\n" + (self.finalParameters()?.description ?? "api is not a json type")
    }
}

///项目可以扩展该类型设置默认值
public protocol ECCustomApiType: ECApiType {
}
extension ECCustomApiType {
}

// MARK: 接口类型

///一般使用的强类型接口，可直接当成ECDataProviderType使用
public protocol ECResponseApiType: ECCustomApiType, ECDataProviderType where DataType == ResponseType {
    ///响应结构
    associatedtype ResponseType: ECApiResponseType
}
extension ECResponseApiType {
    public func easyData(completion: @escaping (Swift.Result<DataType, Error>) -> Void) {
        self.manager.request(self, callbackQueue: nil, progress: nil, completion: completion)
    }
}

// MARK: 列表及分页接口类型

///列表接口
public protocol ECListResponseApiType: ECResponseApiType, ECDataListProviderType where ResponseType: ECApiListResponseType, ModelType == ResponseType.ModelType {
    
}
extension ECListResponseApiType {
//    public typealias SectionType = String
    public func list(for data: DataType) -> [ModelType] {
        return data.list ?? []
    }
}
///分页接口
public protocol ECPagedResponseApiType: ECListResponseApiType, ECApiPagedListRequestType, ECDataPagedProviderType where ResponseType: ECApiPagedListResponseType, ModelType == ResponseType.ModelType {
    
}
///转分页相关操作转移支ResponseType
extension ECPagedResponseApiType {
//    public typealias ModelType = ResponseType.ModelType
    public func isLastPage(for data: DataType) -> Bool {
        return data.isEnd(for: self)
    }
    public func merge(data1: DataType, data2: DataType) -> DataType {
        return data1.merge(data: data2)
    }
}

// MARK: 上传接口类型

///上传接口
public protocol ECUploadApiType: ECResponseApiType {
    var datas: [Moya.MultipartFormData] { get }
}
extension ECUploadApiType {
    public var method: Moya.Method { return .post }
    ///默认get参数则放在URL，其他放在body
    public var task: Task {
        if let json = self.toJSON(), json.count > 0 {
            return .uploadCompositeMultipart(self.datas, urlParameters: json)
        }else{
            return .uploadMultipart(self.datas)
        }
    }
}

// MARK: 下载接口类型

extension URL: ECApiResponseType {
    public var error: Error? {
        return nil
    }
    
    public init() {
        fatalError("不可空")
    }
}
///下载接口
public protocol ECDownloadApiType: ECResponseApiType where ResponseType == URL {
    ///下载地址，默认放缓存目录
    var destination: DownloadDestination { get }
}
extension ECDownloadApiType {
    public var destination: DownloadDestination {
        return DownloadRequest.suggestedDownloadDestination(for: .cachesDirectory, in: .userDomainMask)
    }
    ///默认get参数则放在URL，其他放在body
    public var task: Task {
        if let json = self.finalParameters() {
            let encoding: ParameterEncoding
            switch self.method {
            case .get: encoding = URLEncoding.queryString
            default: encoding = JSONEncoding.default
            }
            return .downloadParameters(parameters: json, encoding: encoding, destination: self.destination)
        }else{
            return .downloadDestination(self.destination)
        }
    }
//    public mutating func mapping(mapper: HelpingMapper) {
//        mapper >>> self.destinationURL
//    }
}
