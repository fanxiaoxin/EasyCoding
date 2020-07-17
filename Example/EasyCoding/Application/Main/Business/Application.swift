//
//  Application.swift
//  YCP
//
//  Created by Fanxx on 2019/7/30.
//  Copyright © 2019 Ycp. All rights reserved.
//

import UIKit
import EasyCoding

class Application: Business {
    static let shared = Application()

    ///示例模块
    let example = ExampleBusiness()
    
    ///在APPDelegate加载完后调用
    func load() {
        Style.load()
    }
}

let APP = Application.shared
