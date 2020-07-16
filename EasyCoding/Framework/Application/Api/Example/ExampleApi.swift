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
