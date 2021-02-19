//
//  SkinManagement.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/11/20.
//

import UIKit

///皮肤应用操作
public protocol EasySkinizable: EasyPersonalizable {
    ///应用皮肤
    func apply(skin: EasySkinType)
}
///特定类型的多语言操作
public protocol EasyDesignedSkinizable: EasySkinizable {
    associatedtype SkinType: EasySkinType
    func apply(skin: SkinType)
}
extension EasyDesignedSkinizable {
    public func apply(skin: EasySkinType) {
        if let t = skin as? SkinType {
            self.apply(skin: t)
        }
    }
}
///皮肤
public protocol EasySkinType: EasyPersonalizedProviderType {
    ///获取对应键的颜色
    subscript(index: String) -> UIColor { get }
}
extension EasySkinType {
    ///应用到某个操作
    public func apply(to target: EasyPersonalizable) {
        if let t = target as? EasySkinizable {
            t.apply(skin: self)
        }
    }
}
///皮肤管理器，负责切换皮肤等操作
public protocol EasySkinManagerType: EasyPersonalizedManagerType where ProviderType: EasySkinType {
    
}
