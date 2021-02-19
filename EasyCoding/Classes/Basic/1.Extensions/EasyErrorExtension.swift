//
//  EasyErrorExtension.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/29.
//

import UIKit

public extension NSError {
    static func easy(domain: String = "EasyCoding", code: Int = -1, info: String) -> NSError {
        return NSError(domain: domain, code: code, userInfo: [NSLocalizedDescriptionKey: info])
    }
}
