//
//  ECCollectinoViewStyle.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/6.
//

import UIKit

extension ECStyleSetting where TargetType: UICollectionView {
    ///选择
    public static func selection(_ allows:Bool = true) -> ECStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.allowsSelection = allows
        })
    }
    ///选择
    public static func selection(multiple allows:Bool = true) -> ECStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.allowsMultipleSelection = allows
        })
    }
    ///注册Cell缓存类型
    public static func cell(_ cls: AnyClass, identifier: String = "Default") -> ECStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.register(cls, forCellWithReuseIdentifier: identifier)
        })
    }
    ///注册Header缓存类型
    public static func header(_ cls: AnyClass, identifier: String = "Default") -> ECStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.register(cls, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier)
        })
    }
    ///注册Footer缓存类型
    public static func footer(_ cls: AnyClass, identifier: String = "Default") -> ECStyleSetting<TargetType> {
        return .init(action: { (target) in
        target.register(cls, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: identifier)
        })
    }
}
