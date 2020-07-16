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

struct ApiManager {
    ///默认的Api管理器
    class Default: ECApiManagerType {
        #if DEBUG
        var plugins:[PluginType] = [ApiPlugin.Logger()]
        #else
        var plugins:[PluginType] = []
        #endif
    }
    ///显式API调用(默认通用，在失败时会弹toast)
    static let shared = Default()
    ///添加通用插件
    static func append(plugin: PluginType) {
        Self.shared.plugins.append(plugin)
    }
}
