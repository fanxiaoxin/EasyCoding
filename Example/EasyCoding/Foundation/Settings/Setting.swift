//
//  Setting.swift
//  YCP
//
//  Created by Fanxx on 2019/7/2.
//  Copyright © 2019 Ycp. All rights reserved.
//

import UIKit

///公共配置
struct Setting {
    ///接口
    struct Api {
        ///接口地址
        static var url = "https://www.baidu.com"
    }
    ///外部参数
    struct External {
        //Bugly
        struct Bugly {
            static let appId = ""
        }
        ///友盟
        struct UMMeng {
            static let appKey = ""
        }
    }
}
