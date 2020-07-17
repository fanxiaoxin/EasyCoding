//
//  UserDefaults.swift
//  WTVideo
//
//  Created by JY_NEW on 2020/6/10.
//  Copyright © 2020 JunYue. All rights reserved.
//

import UIKit
import EasyCoding

///存放UserDefaults的公共Key
struct UserDefaults {
    struct Example {
        @ECProperty.UserDefault("Example.test", defaultValue: "")
        static var test: String
    }
}
