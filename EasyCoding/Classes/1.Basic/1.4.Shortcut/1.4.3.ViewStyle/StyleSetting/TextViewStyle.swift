//
//  TextViewStyle.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/8/12.
//

import UIKit

extension ECStyleSetting where TargetType: UITextView {
    ///文本
    public static func text(_ text:String?) -> ECStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.text = text
        })
    }
    ///富文本
    public static func text(_ text:NSAttributedString?) -> ECStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.attributedText = text
        })
    }
    ///富文本
    public static func attr(_ text:NSAttributedString?) -> ECStyleSetting<TargetType> {
        return self.text(text)
    }
    ///字体
    public static func font(_ font:UIFont?) -> ECStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.font = font
        })
    }
    ///系统字体
    public static var systemFont:ECStyleSetting<TargetType> { return .font(UIFont.systemFont(ofSize: UIFont.systemFontSize))}
    ///系统字体
    public static func font(size: CGFloat) -> ECStyleSetting<TargetType> { return .font(UIFont.systemFont(ofSize: size))}
    ///系统字体
    public static func boldFont(size: CGFloat) -> ECStyleSetting<TargetType> { return .font(UIFont.boldSystemFont(ofSize: size))}
    
    ///文本颜色
    public static func color(_ color:UIColor?) -> ECStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.textColor = color
        })
    }
    ///文本颜色
    public static func color(rgb color:UInt32) -> ECStyleSetting<TargetType> {
        return .color(UIColor.easy.rgb( color))
    }
    ///对齐
    public static func align(_ align:NSTextAlignment) -> ECStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.textAlignment = align
        })
    }
    ///居中对齐
    public static var center: ECStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.textAlignment = .center
        })
    }
    ///键盘
    public static func keyboard(_ type:UIKeyboardType) -> ECStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.keyboardType = type
        })
    }
}