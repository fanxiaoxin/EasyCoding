//
//  ApiTest.swift
//  YCP
//
//  Created by Fanxx on 2019/7/17.
//  Copyright © 2019 Ycp. All rights reserved.
//

import UIKit
import HandyJSON

protocol ApiTestType {
    
}

extension Api {
    struct Test {
        class Model: HandyJSON{
            required init() {}
            var text: String?
        }
        class List: ApiType, ApiTestType {
            var path: String {
                return "TEST"
            }
            
            typealias ResponseType = Api.Structure.Response.CommonList<Model>
            required init() {
                
            }
            public var sampleData: Data {
                let data: [String: Any] =  ["code": "1",
                                            "msg": "请求成功",
                                            "time": Date().timeIntervalSince1970.description,
                                            "data": [
                                                "list": [["text":"内容1"],["text":"内容2"],["text":"内容3"],["text":"内容4"]]
                    ]]
                return try! JSONSerialization.data(withJSONObject: data, options: JSONSerialization.WritingOptions.prettyPrinted)
            }
        }
        
        class PagedList: PagedListApiType, ApiTestType {
            
            typealias ResponseType = Api.Structure.Response.CommonPagedList<Model>
            
            var path: String {
                return "TEST"
            }
            required init() {
                
            }
            var page: Int = 1
            public var sampleData: Data {
                let data: [String: Any] =  ["code": "1",
                                            "msg": "请求成功",
                                            "time": Date().timeIntervalSince1970.description,
                                            "data": [
                                                "list": [["text":"内容1"],["text":"内容2"],["text":"内容3"],["text":"内容4"]]
                    ]]
                return try! JSONSerialization.data(withJSONObject: data, options: JSONSerialization.WritingOptions.prettyPrinted)
            }
        }
    }
    
}
