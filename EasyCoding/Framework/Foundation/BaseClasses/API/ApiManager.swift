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
        ///默认的Api管理器
        class Default: ECApiManagerType {
            #if DEBUG
            var plugins:[PluginType] = [Api.Plugin.Logger()]
            #else
            var plugins:[PluginType] = []
            #endif
            func provider<ApiType>(for api: ApiType) -> MoyaProvider<ApiType> where ApiType : ECApiType {
                if api is ApiTestType {
                    //测试接口延时1秒钟
                    return MoyaProvider<ApiType>(stubClosure: MoyaProvider.delayedStub(1), plugins:self.plugins)
                }else{
                    return MoyaProvider<ApiType>(plugins:self.plugins)
                }
            }
        }
        ///显式API调用(默认通用，在失败时会弹toast)
        static let shared = Default()
        ///添加通用插件
        static func append(plugin: PluginType) {
            Self.shared.plugins.append(plugin)
        }
    }
}
