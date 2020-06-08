//
//  ThemeManagement.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/11/20.
//

import UIKit

///主题应用操作
public protocol ECThemeizable: ECPersonalizable {
    ///应用主题
    func apply(theme: ECThemeType)
}
///特定类型的多语言操作
public protocol ECDesignedThemeizable: ECThemeizable {
    associatedtype ThemeType: ECThemeType
    func apply(theme: ThemeType)
}
extension ECDesignedThemeizable {
    public func apply(theme: ECThemeType) {
        if let t = theme as? ThemeType {
            self.apply(theme: t)
        }
    }
}
///主题
public protocol ECThemeType: ECPersonalizedProviderType {
    ///获取对应键的颜色
    subscript(index: String) -> UIColor { get }
}
extension ECThemeType {
    ///应用到某个操作
    public func apply(to target: ECPersonalizable) {
        if let t = target as? ECThemeizable {
            t.apply(theme: self)
        }
    }
}
///主题管理器，负责切换主题等操作
public protocol ECThemeManagerType: ECPersonalizedManagerType where ProviderType: ECThemeType {
    
}
