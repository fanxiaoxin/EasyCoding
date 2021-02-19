//
//  EasyBooleanType.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/23.
//

import UIKit

///可使用于可判断是否的类型
public protocol EasyBooleanType {
    ///正向的，正值，是，成功，通过等正面值
    var isPositive: Bool { get }
}
extension EasyBooleanType {
    ///负向的，负值，否，失败，拒绝等负面值
    public var isNegative: Bool {
        return !self.isPositive
    }
    ///是
    public var yes: Bool {
        return self.isPositive
    }
    ///否
    public var no: Bool {
        return self.isNegative
    }
    ///成功
    public var success: Bool {
        return self.isPositive
    }
    ///失败
    public var failure: Bool {
        return self.isNegative
    }
    ///通过
    public var passed: Bool {
        return self.isPositive
    }
    ///拒绝
    public var rejected: Bool {
        return self.isNegative
    }
}
extension Bool: EasyBooleanType {
    public var isPositive: Bool { return self }
}
extension Swift.Result: EasyBooleanType {
    public var isPositive: Bool {
        switch self {
        case .success(_): return true
        case .failure(_): return false
        }
    }
}
