//
//  Apis.swift
//  FXFramework
//
//  Created by Fanxx on 2019/6/10.
//  Copyright © 2019 fanxx. All rights reserved.
//

import UIKit
import EasyCoding
import HandyJSON

extension Api {
    struct Structure {
        ///放置请求通用结构
        struct Request { }
        ///放置响应通用结构
        struct Response { }
        ///放置响应数据结构
        struct Data { }
    }
}
///API响应的Model自定义错误
protocol ApiResponseDataError {
    ///定制自己的错误内容
    var dataError: Error? { get }
}
extension Api.Structure.Request {
    ///放置请求通用参数
    class ParamterFomatter: ECApiParametersFomatterType {
        ///用于存放业务通用的参数，如登录后的接口全部添加token
        static var extParams: [String: Any] = [:]
        func format(api: ECApiType) -> [String : Any]? {
            var params = api.parameters ?? [:]
            params.merge(ParamterFomatter.extParams) { (p, _) in p }
            // 设备号
            //                let timestamp = Date().timeIntervalSince1970
            //                params["timestamp"] = timestamp
            //额外添加手机信息，方便排查BUG
            //手机型号; 系统版本; App版本
            //iPhone X; iOS 12.4; v3.0.0
            params["__app_info"] = UIDevice.current.easy.modelName + "; iOS " + UIDevice.current.systemVersion + "; v" + Bundle.main.easy.version
            return params;
        }
    }
}
extension Api.Structure.Response {
    ///接口返回的通用结构及错误封装
    class Common<DataType:HandyJSON>: ECApiResponseType {
        var data: DataType?
        var code: Int = 0
        var msg: String?
        ///服务器当前时间
        var time: Date?
        
        var error: Error? {
            if self.code != 1 {
                return self.mappingError(self.msg ?? "数据请求失败")
            }
            if let data = self.data as? ApiResponseDataError {
                if let error = data.dataError {
                    return error
                }
            }
            return nil
        }
        
        func mappingError(_ info:String) -> Error {
            return NSError(domain: "ApiModel", code: 999, userInfo: [NSLocalizedDescriptionKey: info])
        }
        required init() {
            
        }
        func mapping(mapper: HelpingMapper) {
            mapper <<< self.time <-- ECHandyJSON.MillisecondDateTransform()
        }
    }
}
//列表
extension Api.Structure.Data {
    class List<ModelType:HandyJSON>: HandyJSON {
        var list: [ModelType]?
        required init() { }
    }
}

extension Api.Structure.Response {
    ///附带其他参数的列表
    class List<ModelType: HandyJSON, DataType: Api.Structure.Data.List<ModelType>>: Common<DataType>, ECApiListResponseType {
        var list: [ModelType]? {
            return self.data?.list
        }
        required init() {
            
        }
    }
    ///通用的列表，只有列表没有其他参数
    typealias CommonList<ModelType: HandyJSON> = List<ModelType, Api.Structure.Data.List<ModelType>>
}

extension Api.Structure.Data {
    class PagedList<ModelType:HandyJSON>: List<ModelType> {
        ///页码
        var page: Int = 0
        required init() { }
    }
}

extension Api.Structure.Response {
    ///附带其他参数的列表
    class PagedList<ModelType: HandyJSON, DataType: Api.Structure.Data.PagedList<ModelType>>:List<ModelType, DataType>, ECApiPagedListResponseType {
        func merge(data: Api.Structure.Response.PagedList<ModelType, DataType>) -> Self {
            if self.data?.list != nil, let list = data.list {
                self.data?.list?.append(contentsOf: list)
            }
            return self
        }
        
        func isEnd(for api: ECApiPagedListRequestType) -> Bool {
            return self.list?.count ?? 0 <= 0
        }
        required init() {
            
        }
    }
    ///通用的列表，只有列表没有其他参数
    typealias CommonPagedList<ModelType: HandyJSON> = PagedList<ModelType, Api.Structure.Data.PagedList<ModelType>>
}
