//
//  SkinManagement.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/11/20.
//

import UIKit

///皮肤应用操作
public protocol ECSkinizable: ECPersonalizable {
    ///应用皮肤
    func apply(skin: ECSkinType)
}
///特定类型的多语言操作
public protocol ECDesignedSkinizable: ECSkinizable {
    associatedtype SkinType: ECSkinType
    func apply(skin: SkinType)
}
extension ECDesignedSkinizable {
    public func apply(skin: ECSkinType) {
        if let t = skin as? SkinType {
            self.apply(skin: t)
        }
    }
}
///皮肤
public protocol ECSkinType: ECPersonalizedProviderType {
    ///获取对应键的颜色
    subscript(index: String) -> UIColor { get }
}
extension ECSkinType {
    ///应用到某个操作
    public func apply(to target: ECPersonalizable) {
        if let t = target as? ECSkinizable {
            t.apply(skin: self)
        }
    }
}
///皮肤管理器，负责切换皮肤等操作
public protocol ECSkinManagerType: ECPersonalizedManagerType where ProviderType: ECSkinType {
    
}
