//
//  Null.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/6.
//

import UIKit

///空的结构体，用于泛型不需要参数时
public struct ECNull: Equatable {
    ///唯一值
    public static let null = ECNull()
    ///唯一值
    public static var value: ECNull { return .null }
    public init() {
        
    }
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return true
    }
    ///空的类，用于泛型不需要参数时
    public class Cls: Equatable {
        ///唯一值
        public static let null = Cls()
        private init() { }
        public static func == (lhs: ECNull.Cls, rhs: ECNull.Cls) -> Bool {
            return true
        }
    }
}
