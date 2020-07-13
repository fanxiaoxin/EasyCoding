//
//  Notifications.swift
//  EasyCoding_Example
//
//  Created by JY_NEW on 2020/7/11.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

///通知Key
struct Notification {
    static func name(_ key: String) -> NSNotification.Name {
        return NSNotification.Name(rawValue: key)
    }
    struct Example {
        static let test = name("Example.test")
    }
}
