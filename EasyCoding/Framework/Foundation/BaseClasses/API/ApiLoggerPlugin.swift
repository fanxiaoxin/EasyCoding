//
//  ApiLoggerPlugin.swift
//  YCP
//
//  Created by Fanxx on 2019/7/2.
//  Copyright © 2019 Ycp. All rights reserved.
//

import UIKit
import Result
import Moya

extension Api {
    struct Plugin {
        ///日志
        class Logger: PluginType {
            public func willSend(_ request: RequestType, target: TargetType) {
                var params = (target as! ECApiType).parameters ?? [:]
                params.merge(Api.Structure.Request.ParamterFomatter.extParams, uniquingKeysWith: { p, _ in p })
                print("发起请求: \(request.request?.httpMethod ?? "Unkonw") - \(target.baseURL.absoluteString + "/" + target.path)\n参数: \(params)")
            }
            public func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
                let res:String
                switch result {
                case let .success(response):
                    do {
                        res = try response.mapString()
                    }catch {
                        res = "转换数据为字符串失败"
                    }
                case let .failure(error):
                    res = "失败：" + (error.errorDescription ?? "没有错误信息")
                }
                print("请求结果: \(target.baseURL.absoluteString + "/" + target.path)\n返回: \(res)")
            }
        }
    }
}
