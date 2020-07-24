//
//  ApiTest.swift
//  YCP
//
//  Created by Fanxx on 2019/7/17.
//  Copyright © 2019 Ycp. All rights reserved.
//

import UIKit
import HandyJSON
import EasyCoding

///测试接口
struct ApiTest {
    class Model: HandyJSON, ECTextualizable{
        required init() {}
        var friendlyText: String = "测试文字"
    }
    ///一般测试接口
    class Normal: ApiType, ECApiTestType {
        deinit {
            print("api die")
        }
        typealias ResponseType = ApiStructure.Response.Common<Model>
        required init() {
            
        }
        var isError: Bool = false
        var response: ResponseType {
            let common = ApiStructure.Response.Common<Model>()
            common.code = isError ? 0 : 1
            common.msg = isError ? "测试请求出错" : "成功"
            common.time = Date()
            common.data = Model()
            return common
        }
    }
    ///列表测试接口
    class List: ListApiType, ECApiTestType {
        typealias ResponseType = ApiStructure.Response.CommonList<Model>
        required init() {
            
        }
        var isError: Bool = false
        var response: ResponseType {
            let list = ApiStructure.Response.CommonList<Model>()
            list.code = 1
            list.msg = isError ? "测试请求出错" : "成功"
            list.time = Date()
            list.data = ApiStructure.Data.List()
            list.data?.list = [Model(),Model(),Model(),Model(),Model(),Model(),Model()]
            return list
        }
    }
    ///分页测试接口
    class PagedList: PagedListApiType, ECApiTestType {
        typealias ResponseType = ApiStructure.Response.CommonPagedList<Model>
        required init() {
            
        }
        var page: Int = 1
        var isError: Bool = false
        var response: ResponseType {
            let list = ApiStructure.Response.CommonPagedList<Model>()
            list.code = 1
            list.msg = isError ? "测试请求出错" : "成功"
            list.time = Date()
            list.data = ApiStructure.Data.PagedList()
            if self.page > 3 {
                list.data?.list = []
            }else{
                list.data?.list = [Model(),Model(),Model(),Model(),Model(),Model(),Model()]
            }
            return list
        }
    }
}

