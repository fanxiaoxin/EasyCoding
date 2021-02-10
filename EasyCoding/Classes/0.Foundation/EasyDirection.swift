//
//  Direction.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/11/19.
//

import UIKit

///方向，可多选
public struct EasyDirection : OptionSet{
    public var rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
    public static var none: Self {
        return Self(rawValue: 0)
    }
    public static var top: Self {
        return Self(rawValue: 1)
    }
    public static var left: Self {
        return Self(rawValue: 2)
    }
    public static var bottom: Self {
        return Self(rawValue: 4)
    }
    public static var right: Self {
        return Self(rawValue: 8)
    }
}
///方向
public enum EasyOrientation {
    ///横向
    case landscape
    ///竖向
    case portrait
}
extension EasyOrientation {
    ///横向
    public var horizontal: Self { return .landscape}
    ///竖向
    public var vertical: Self { return .portrait}
}
