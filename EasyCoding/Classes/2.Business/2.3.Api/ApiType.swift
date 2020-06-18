
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

///一个接口一个类
public protocol ECApiType: TargetType, HandyJSON {
    var parameters: [String: Any]? { get }
    ///传入parameters的返回值
    var paramtersFormatter: ECApiParametersFomatterType? { get }
    ///是否将参数放于Body中否则放URL，默认GET放URL，其他放Body
    var isBodyParamters: Bool { get }
}
///配置默认值
extension ECApiType {
    public var method: Moya.Method { return .get }
    public var sampleData: Data { return "empty sample data".data(using: .utf8)! }
    public var headers: [String: String]? { return ["Content-type": "application/json"] }
    public var parameters: [String: Any]? { return self.toJSON() }
    public var paramtersFormatter: ECApiParametersFomatterType? { return nil }
    
    public func finalParameters() -> [String: Any]? {
        if let fomatter = self.paramtersFormatter {
            return fomatter.format(api: self)
        }else{
            return self.parameters
        }
    }
    public var isBodyParamters: Bool { return self.method == .get ? false : true }
}
///比较简单的接口，没有返回值
public protocol ECSimpleApiType: ECApiType {
}
extension ECSimpleApiType {
    ///默认get参数则放在URL，其他放在body
    public var task: Task {
        if let json = self.finalParameters() {
            /*
            switch self.method {
            case .get:
                return .requestParameters(parameters: json, encoding: URLEncoding.queryString)
            default:
                return .requestCompositeParameters(bodyParameters: json, bodyEncoding: JSONEncoding.default, urlParameters: json)
            }*/
            if self.isBodyParamters {
                return .requestParameters(parameters: json, encoding: JSONEncoding.default)
            }else{
                return .requestParameters(parameters: json, encoding: URLEncoding.queryString)
            }
        }else{
            return .requestPlain
        }
    }
}
public protocol ECResponseApiType: ECSimpleApiType {
    ///响应结构
    associatedtype ResponseType: ECApiResponseType
}
public protocol ECPagedResponseApiType: ECResponseApiType, ECApiPagedListRequestType where Self.ResponseType: ECApiPagedListResponseType {
    ///页面请求结构
//    associatedtype PagedInfoType: ECApiPagedListRequestType
//    var page:PagedInfoType { get set }
}
//extension ECPagedResponseApiType {
//    public var parameters: [String : Any]? {
//        let json = self.toJSON()
//        let page = self.page.toJSON()
//        guard var json1 = json else {
//            return page
//        }
//        guard let json2 = page else {
//            return json
//        }
//        json1.merge(json2, uniquingKeysWith: { v1,_ in v1 })
//        return json1
//    }
//    public mutating func mapping(mapper: HelpingMapper) {
//        mapper >>> self.page
//    }
//}
///上传接口
public protocol ECUploadApiType: ECSimpleApiType {
    var datas: [MultipartFormData] { get }
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
///下载接口
public protocol ECDownloadApiType: ECSimpleApiType {
    var destination: DownloadDestination { get set }
}
extension ECDownloadApiType {
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
    public mutating func mapping(mapper: HelpingMapper) {
        mapper >>> self.destination
    }
}
