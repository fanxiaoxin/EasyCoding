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

struct ApiStructure {
    ///放置请求通用结构
    struct Request { }
    ///放置响应通用结构
    struct Response { }
    ///放置响应数据结构
    struct Data { }
}
///API响应的Model自定义错误
protocol ApiResponseDataError {
    ///定制自己的错误内容
    var dataError: Error? { get }
}
extension ApiStructure.Response {
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
extension ApiStructure.Data {
    class List<ModelType:HandyJSON>: HandyJSON {
        var list: [ModelType]?
        required init() { }
    }
}

extension ApiStructure.Response {
    ///附带其他参数的列表
    class List<ModelType: HandyJSON, DataType: ApiStructure.Data.List<ModelType>>: Common<DataType>, ECApiListResponseType {
        var list: [ModelType]? {
            return self.data?.list
        }
        required init() {
            
        }
    }
    ///通用的列表，只有列表没有其他参数
    typealias CommonList<ModelType: HandyJSON> = List<ModelType, ApiStructure.Data.List<ModelType>>
}

extension ApiStructure.Data {
    class PagedList<ModelType:HandyJSON>: List<ModelType> {
        //此处放置Page的通用字段，如page, page_size, total等
        required init() { }
    }
}

extension ApiStructure.Response {
    ///附带其他参数的列表
    class PagedList<ModelType: HandyJSON, DataType: ApiStructure.Data.PagedList<ModelType>>:List<ModelType, DataType>, ECApiPagedListResponseType {
        func merge(data: ApiStructure.Response.PagedList<ModelType, DataType>) -> Self {
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
    typealias CommonPagedList<ModelType: HandyJSON> = PagedList<ModelType, ApiStructure.Data.PagedList<ModelType>>
}
