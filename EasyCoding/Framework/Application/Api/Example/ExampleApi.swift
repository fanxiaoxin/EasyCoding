//
//  ExampleApi.swift
//  WTVideo
//
//  Created by JY_NEW on 2020/6/11.
//  Copyright © 2020 JunYue. All rights reserved.
//

import UIKit
import Moya

extension Api {
    class Example: ApiType, ApiTestType {
        typealias ResponseType = Structure.Response.Common<Test.Model>
        
        var path: String {
            return "example"
        }
        var method: Moya.Method {
            return .get
        }
        
        var sampleData: Data {
            let data: [String: Any] = ["return_code": "SUCCESS",
                                       "result_code": "SUCCESS",
                                       "data": [
                                           "list": [["text":"内容1"],["text":"内容2"],["text":"内容3"],["text":"内容4"]],
                                           "phone": self.phone ?? "nil"
                                       ]]
            return try! JSONSerialization.data(withJSONObject: data, options: JSONSerialization.WritingOptions.prettyPrinted)
        }
        required init() {}

        var phone: String?
    }
}
