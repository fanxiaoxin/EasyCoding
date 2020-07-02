//
//  StyleSetting.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/6/3.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import UIKit

public struct ECStyleSetting<TargetType> {
    public var action:(TargetType) -> Void
    public init(action: @escaping (TargetType) -> Void) {
        self.action = action
    }
}
///所有需要设置样式的都可继承该协议
public protocol ECStyleSetable { }
extension EC.NamespaceImplement where Base: ECStyleSetable {
    @discardableResult
    public func style(_ style:ECStyleSetting<Base>...) -> NamespaceWrapper<Base> {
        style.forEach({$0.action(self.base)})
        return self as! NamespaceWrapper<Base> 
    }
}
extension EC.NamespaceImplement where Base == [UIView] {
    @discardableResult
    public func style(_ style:ECStyleSetting<Base.Element>...) -> NamespaceWrapper<Base> {
        self.base.forEach { (obj) in
            style.forEach({ $0.action(obj)})
        }
        return self as! NamespaceWrapper<Base>
    }
}
///UIView默认可设置样式
extension UIView: ECStyleSetable { }
extension ECStyleSetable where Self: UIView {
    public static func easy(_ styles:ECStyleSetting<Self>...) -> Self {
        return self.init().easy(styles: styles)
    }
    @discardableResult
    public func easy(_ styles:ECStyleSetting<Self>...) -> Self {
        return self.easy(styles: styles)
    }
    @discardableResult
    public func easy(styles:[ECStyleSetting<Self>]) -> Self {
        styles.forEach({$0.action(self)})
        return self
    }
}
extension ECStyleSetting {
    ///组合多个样式
    public static func sheet(_ styles:ECStyleSetting<TargetType>...) -> ECStyleSetting<TargetType> {
        return .init(action: { (target) in
            styles.forEach({ $0.action(target) })
        })
    }
    ///自定义
    public static func custom(_ action:@escaping (TargetType) -> Void) -> ECStyleSetting<TargetType> {
        return .init(action: action)
    }
}

///静态样式表
var ECStaticStyleSheets: [String:Any] = [:]
extension EC.NamespaceImplement where Base: ECStyleSetable {
    ///设置静态样式
    public static func style(_ style:ECStyleSetting<Base>...) {
        let className = String(describing: type(of: Base.self))
        ECStaticStyleSheets[className] = style
    }
    ///加载静态样式
    public func loadStaticStyle() {
        let className = String(describing: type(of: Base.self))
        if let styles = ECStaticStyleSheets[className] as? [ECStyleSetting<Base>] {
            styles.forEach({ $0.action(self.base) })
        }
    }
}
