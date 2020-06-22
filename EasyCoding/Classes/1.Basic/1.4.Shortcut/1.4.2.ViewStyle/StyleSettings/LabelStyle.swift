//
//  LabelStyle.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/5/31.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import UIKit

extension ECStyleSetting where TargetType: UILabel {
    ///文本
    public static func text(_ text:ECControlTextType?) -> ECStyleSetting<TargetType> {
        return .init(action: { (target) in
            text?.setText(to: target)
        })
    }
    ///富文本
    public static func attr(_ text:ECAttributedString?) -> ECStyleSetting<TargetType> {
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
    ///最大显示行数
    public static func lines(_ lines:Int = 0) -> ECStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.numberOfLines = lines
        })
    }
    ///字体最小比例
    public static func min(scale:CGFloat) -> ECStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.adjustsFontSizeToFitWidth = true
            target.minimumScaleFactor = scale
        })
    }
    ///字体最小尺寸
    public static func min(size:CGFloat) -> ECStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.adjustsFontSizeToFitWidth = false
            target.minimumScaleFactor = size
        })
    }
}
extension ECStyleSetable where Self: UILabel {
    public static func easy(text: String? = nil, font: UIFont, color: UIColor?) -> Self {
        let o = self.init()
        o.text = text
        o.font = font
        o.textColor = color
        return o
    }
}
