//
//  ProviderCenter.swift
//  FXFramework
//
//  Created by Fanxx on 2019/6/10.
//  Copyright © 2019 fanxx. All rights reserved.
//

import UIKit
import EasyCoding
import Moya

extension Api {
    struct Manager {
        ///隐形调用
        class Implicit: ECApiManagerType {
            #if DEBUG
            var plugins:[PluginType] = [Api.Plugin.Logger()]
            #else
            var plugins:[PluginType] = []
            #endif
            func handle(error: Error, for api: ECApiType) {
                
            }
            func provider<ApiType>(for api: ApiType) -> MoyaProvider<ApiType> where ApiType : ECApiType {
                if api is ApiTestType {
                    //测试接口延时1秒钟
                    return MoyaProvider<ApiType>(stubClosure: MoyaProvider.delayedStub(1), callbackQueue: self.callbackQueue, plugins:self.plugins)
                }else{
                    return MoyaProvider<ApiType>(callbackQueue: self.callbackQueue,plugins:self.plugins)
                }
            }
        }
        ///背景线程
        class Background: Implicit {
            ///回调队列
            public var callbackQueue: DispatchQueue? { return DispatchQueue.global() }
        }
        
        class Explicit: Implicit {
            weak var hudController: UIViewController?
            ///显示调用会弹出错误信息
            override func handle(error: Error, for api: ECApiType) {
                    var message = error.localizedDescription
                    if let err = error as? MoyaError {
                        switch err {
                        case .statusCode(let res):
                            switch res.statusCode {
                                case 404: message = "数据异常"
                                default: break
                            }
                        case .underlying(let e, _):
                            switch (e as NSError).code {
                            case -1001: message = "请求超时"
                            case -1009: message = "网络已中断"
                            case -1004, -1005: message = "网络连接失败"
                              default:break
                            }
                        default: break
                        }
                    }
                    ECMessageBox.toast(message)
            }
        }
        ///显式API调用(默认通用，不要去赋值hudController)
        static let `default` = Explicit()
        ///隐式API调用
        static let implicit = Implicit()
        ///后台线程执行
        static let background = Background()
        ///添加通用插件
        static func append(plugin: PluginType) {
            Self.default.plugins.append(plugin)
            Self.implicit.plugins.append(plugin)
            Self.background.plugins.append(plugin)
        }
    }
}
