//
//  Localized.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/11/20.
//

import UIKit

///多语言操作
public protocol ECLocalizable: ECPersonalizable {
    ///设置多语言相关的显示
    func localize(for provider: ECLocalizedProviderType)
}
///特定类型的多语言操作
public protocol ECDesignedLocalizable: ECLocalizable {
    associatedtype ProviderType: ECLocalizedProviderType
    ///设置多语言相关的显示
    func localize(for provider: ProviderType)
}
extension ECDesignedLocalizable {
    public func localize(for provider: ECLocalizedProviderType) {
        if let p = provider as? ProviderType {
            self.localize(for: p)
        }
    }
}
///多语言相关资源提供者
public protocol ECLocalizedProviderType: ECPersonalizedProviderType {
    ///获取对应键的文字
    subscript(index: String) -> String { get }
}
extension ECLocalizedProviderType {
    ///应用到某个操作
    public func apply(to target: ECPersonalizable) {
        if let t = target as? ECLocalizable {
            t.localize(for: self)
        }
    }
}
///多语言操作管理器
public protocol ECLocalizedManagerType: ECPersonalizedManagerType where ProviderType: ECLocalizedProviderType {
    
}
extension ECLocalizedManagerType {
    public subscript(index: String) -> String {
        return self.provider?[index] ?? ""
    }
}
