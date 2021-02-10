//
//  StyleSetting.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/6/3.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import UIKit

public struct EasyStyleSetting<TargetType> {
    public var action:(TargetType) -> Void
    public init(action: @escaping (TargetType) -> Void) {
        self.action = action
    }
}
///所有需要设置样式的都可继承该协议
public protocol EasyStyleSetable { }
extension EasyCoding where Base: EasyStyleSetable {
    @discardableResult
    public func style(animated: Bool = false,_ style:EasyStyleSetting<Base>...) -> EasyNamespaceWrapper<Base> {
        if animated {
            UIView.animate(withDuration: 0.25) {
                style.forEach({$0.action(self.base)})
            }
        } else{
            style.forEach({$0.action(self.base)})
        }
        return self as! EasyNamespaceWrapper<Base>
    }
    @discardableResult
    public func style(animated duration: TimeInterval,_ style:EasyStyleSetting<Base>...) -> EasyNamespaceWrapper<Base> {
        UIView.animate(withDuration: duration) {
            style.forEach({$0.action(self.base)})
        }
        return self as! EasyNamespaceWrapper<Base>
    }
}
extension Easy.NamespaceArrayImplement where Element: UIView {
    @discardableResult
    public func style(animated: Bool = false,_ style:EasyStyleSetting<Element>...) -> EasyNamespaceArrayWrapper<Element> {
        if animated {
            UIView.animate(withDuration: 0.25) {
                self.base.forEach { (obj) in
                    style.forEach({ $0.action(obj)})
                }
            }
        } else{
            self.base.forEach { (obj) in
                style.forEach({ $0.action(obj)})
            }
        }
        return self as! EasyNamespaceArrayWrapper<Element>
    }
    @discardableResult
    public func style(animated duration: TimeInterval,_ style:EasyStyleSetting<Element>...) -> EasyNamespaceArrayWrapper<Element> {
        UIView.animate(withDuration: duration) {
            self.base.forEach { (obj) in
                style.forEach({ $0.action(obj)})
            }
        }
        return self as! EasyNamespaceArrayWrapper<Element>
    }
}
///UIView默认可设置样式
extension UIView: EasyStyleSetable { }
///UICollectionViewLayout默认可设置样式
extension UICollectionViewLayout: EasyStyleSetable { }

extension EasyStyleSetable {
    @discardableResult
    public func easy(_ styles:EasyStyleSetting<Self>...) -> Self {
        return self.easy(styles: styles)
    }
    @discardableResult
    public func easy(styles:[EasyStyleSetting<Self>]) -> Self {
        styles.forEach({$0.action(self)})
        return self
    }
}
extension EasyStyleSetable where Self: EasyEmptyInstantiable {
    public static func easy(_ styles:EasyStyleSetting<Self>...) -> Self {
        return self.init().easy(styles: styles)
    }
    public static func easy(styles:[EasyStyleSetting<Self>]) -> Self {
        return self.init().easy(styles: styles)
    }
}
extension EasyStyleSetting {
    ///组合多个样式
    public static func sheet(_ styles:EasyStyleSetting<TargetType>...) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            styles.forEach({ $0.action(target) })
        })
    }
    ///自定义
    public static func custom(_ action:@escaping (TargetType) -> Void) -> EasyStyleSetting<TargetType> {
        return .init(action: action)
    }
}

///静态样式表
var EasyStaticStyleSheets: [String:Any] = [:]
extension EasyCoding where Base: EasyStyleSetable {
    ///设置静态样式
    public static func style(_ style:EasyStyleSetting<Base>...) {
        let className = String(describing: type(of: Base.self))
        EasyStaticStyleSheets[className] = style
    }
    ///加载静态样式
    public func loadStaticStyle() {
        let className = String(describing: type(of: Base.self))
        if let styles = EasyStaticStyleSheets[className] as? [EasyStyleSetting<Base>] {
            styles.forEach({ $0.action(self.base) })
        }
    }
}
