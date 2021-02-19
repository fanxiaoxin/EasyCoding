//
//  EasyThemeValueType.swift
//  Alamofire
//
//  Created by JY_NEW on 2021/1/8.
//

import Foundation

///主题枚举类型
public protocol EasyThemeEnumType {
    associatedtype RawValue
    var rawValue: RawValue { get }
    init?(rawValue: RawValue)
}
extension EasyThemeEnumType {
    public init?(rawValue: RawValue) {
        return nil
    }
}

///主题表类型：列出所有的主题
public protocol EasyThemeTableType: EasyThemeEnumType {
    ///返回当前主题
    static var current: Self { get }
}

///主题相关值
public protocol EasyThemeValueType: EasyThemeEnumType {
    /// 主题表
    associatedtype ThemeTableType: EasyThemeTableType
}
extension EasyThemeValueType {
    ///获取当前主题
    public var theme: ThemeTableType {
        return ThemeTableType.current
    }
}
