//
//  Localized.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/11/20.
//

import UIKit

///多语言操作
public protocol EasyLocalizable: EasyPersonalizable {
    ///设置多语言相关的显示
    func localize(for provider: EasyLocalizedProviderType)
}
///特定类型的多语言操作
public protocol EasyDesignedLocalizable: EasyLocalizable {
    associatedtype ProviderType: EasyLocalizedProviderType
    ///设置多语言相关的显示
    func localize(for provider: ProviderType)
}
extension EasyDesignedLocalizable {
    public func localize(for provider: EasyLocalizedProviderType) {
        if let p = provider as? ProviderType {
            self.localize(for: p)
        }
    }
}
///多语言相关资源提供者
public protocol EasyLocalizedProviderType: EasyPersonalizedProviderType {
    ///获取对应键的文字
    subscript(index: String) -> String { get }
}
extension EasyLocalizedProviderType {
    ///应用到某个操作
    public func apply(to target: EasyPersonalizable) {
        if let t = target as? EasyLocalizable {
            t.localize(for: self)
        }
    }
}
///多语言操作管理器
public protocol EasyLocalizedManagerType: EasyPersonalizedManagerType where ProviderType: EasyLocalizedProviderType {
    
}
extension EasyLocalizedManagerType {
    public subscript(index: String) -> String {
        return self.provider?[index] ?? ""
    }
}
