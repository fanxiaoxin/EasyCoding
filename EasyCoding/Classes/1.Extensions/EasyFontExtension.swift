//
//  UIFontExtension.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/8.
//

import UIKit

extension EasyCoding where Base == UIFont {
    public var isBold: Bool {
        return self.base.fontDescriptor.symbolicTraits.contains(.traitBold)
    }
    public var isItalic: Bool {
        return self.base.fontDescriptor.symbolicTraits.contains(.traitItalic)
    }
    public var bold: UIFont {
        return UIFont(descriptor: self.base.fontDescriptor.withSymbolicTraits(.traitBold)!, size: self.base.pointSize)
    }
    public var italic: UIFont {
        return UIFont(descriptor: self.base.fontDescriptor.withSymbolicTraits(.traitItalic)!, size: self.base.pointSize)
    }
}

extension UIFont {
    ///使用family name实例化，若没有该字体则返回系统字体
    public static func easy(name: String, size: CGFloat) -> UIFont {
        return UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
extension EasyCoding where Base == UIFont {
    ///苹方简体
    public static func pingfang(_ size: CGFloat) -> UIFont {
        return UIFont.easy(name: "PingFangSC-Regular", size: size)
    }
    ///苹方简体
    public static func pingfang(medium size: CGFloat) -> UIFont {
        return UIFont.easy(name: "PingFangSC-Medium", size: size)
    }
    ///苹方简体
    public static func pingfang(bold size: CGFloat) -> UIFont {
        return UIFont.easy(name: "PingFangSC-Semibold", size: size)
    }
    ///苹方简体
    public static func pingfang(light size: CGFloat) -> UIFont {
        return UIFont.easy(name: "PingFangSC-Light", size: size)
    }
    ///苹方简体
    public static func pingfang(ultralight size: CGFloat) -> UIFont {
        return UIFont.easy(name: "PingFangSC-Ultralight", size: size)
    }
    ///苹方简体
    public static func pingfang(thin size: CGFloat) -> UIFont {
        return UIFont.easy(name: "PingFangSC-Thin", size: size)
    }
}
