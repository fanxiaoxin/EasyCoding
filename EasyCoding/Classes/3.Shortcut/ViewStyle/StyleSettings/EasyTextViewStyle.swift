//
//  TextViewStyle.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/8/12.
//

import UIKit

extension EasyStyleSetting where TargetType: UITextView {
    ///文本
    public static func text(_ text:EasyControlTextType?) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            text?.setText(to: target)
        })
    }
    ///富文本，要在设属性时最后设，否则不会显示定制的样式
    public static func attr(_ text:EasyAttributedString, _ attrs: EasyStringAttribute...) -> EasyStyleSetting<TargetType> {
        if text.attributes != nil {
            text.attributes!.insert(contentsOf: attrs, at: 0)
        }else{
            text.attributes = attrs
        }
        return self.text(text)
    }
    ///字体
    public static func font(_ font:UIFont?) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.font = font
        })
    }
    ///系统字体
    public static var systemFont:EasyStyleSetting<TargetType> { return .font(UIFont.systemFont(ofSize: UIFont.systemFontSize))}
    ///系统字体
    public static func font(size: CGFloat) -> EasyStyleSetting<TargetType> { return .font(UIFont.systemFont(ofSize: size))}
    ///系统字体
    public static func boldFont(size: CGFloat) -> EasyStyleSetting<TargetType> { return .font(UIFont.boldSystemFont(ofSize: size))}
    
    ///文本颜色
    public static func color(_ color:UIColor?) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.textColor = color
        })
    }
    ///文本颜色
    public static func color(rgb color:UInt32) -> EasyStyleSetting<TargetType> {
        return .color(UIColor.easy.rgb( color))
    }
    ///对齐
    public static func align(_ align:NSTextAlignment) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.textAlignment = align
        })
    }
    ///居中对齐
    public static var center: EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.textAlignment = .center
        })
    }
    ///键盘
    public static func keyboard(_ type:UIKeyboardType) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.keyboardType = type
        })
    }
    public static func padding(_ padding:UIEdgeInsets) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.textContainerInset = padding
        })
    }
}
