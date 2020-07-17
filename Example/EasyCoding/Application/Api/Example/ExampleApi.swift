//
//  ExampleApi.swift
//  WTVideo
//
//  Created by JY_NEW on 2020/6/11.
//  Copyright © 2020 JunYue. All rights reserved.
//

import UIKit
import Moya
import EasyCoding

extension Api {
    class Example: ApiType {
        typealias ResponseType = ApiStructure.Response.Common<ApiTest.Model>
        
        var path: String {
            return "example"
        }
        var method: Moya.Method {
            return .get
        }
        
        required init() {}

        var paramter: String?
        
    }
}
///此为测试接口
extension Api.Example: ECApiTestType {
    var response: ApiStructure.Response.Common<ApiTest.Model> {
        let common = ResponseType()
        common.code = 1
        common.msg = "成功"
        common.time = Date()
        common.data = ApiTest.Model()
        return common
    }
}
