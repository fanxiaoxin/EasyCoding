//
//  ButtonStyle.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/6/3.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import UIKit

extension EasyStyleSetting where TargetType: UIButton {
    ///文本
    public static func text(_ text:EasyControlTextType?, for state: UIControl.State = .normal) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            text?.setText(to: target, for: state)
        })
    }
    ///富文本，要在设属性时最后设，否则不会显示定制的样式
    public static func attr(_ text:EasyAttributedString, _ attrs: EasyStringAttribute..., for state: UIControl.State = .normal) -> EasyStyleSetting<TargetType> {
        if text.attributes != nil {
            text.attributes!.insert(contentsOf: attrs, at: 0)
        }else{
            text.attributes = attrs
        }
        return self.text(text, for: state)
    }
    ///图片
    public static func image(_ image:UIImage?, for state: UIControl.State = .normal) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.setImage(image, for: state)
        })
    }
    ///图片
    public static func image(_ named:String, tint color: UIColor? = nil, for state: UIControl.State = .normal) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            var img = UIImage(named: named)
            if let tint = color {
                img = img?.easy.by(tint: tint)
            }
            target.setImage(img, for: state)
        })
    }
    ///旋转图片图片
    public static func rotate(image degrees:CGFloat, for state: UIControl.State = .normal) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            if let img = target.image(for: state) {
                let r = img.easy.by(rotate: degrees.easy.degreesToRadians)
                target.setImage(r, for: state)
            }
        })
    }
    ///字体
    public static func font(_ font:UIFont?) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.titleLabel?.font = font
        })
    }
    ///系统字体
    public static var systemFont:EasyStyleSetting<TargetType> { return .font(UIFont.systemFont(ofSize: UIFont.systemFontSize))}
    ///系统字体
    public static func font(size: CGFloat) -> EasyStyleSetting<TargetType> { return .font(UIFont.systemFont(ofSize: size))}
    ///系统字体
    public static func boldFont(size: CGFloat) -> EasyStyleSetting<TargetType> { return .font(UIFont.boldSystemFont(ofSize: size))}
    
    ///文本颜色
    public static func color(_ color:UIColor?, for state:UIControl.State...) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            if state.count > 0 {
                for s in state {
                    target.setTitleColor(color, for: s)
                }
            }else{
                target.setTitleColor(color, for: .normal)
            }
        })
    }
    ///文本颜色
    public static func color(rgb color:UInt32, for state:UIControl.State...) -> EasyStyleSetting<TargetType> {
        let color = UIColor.easy.rgb( color)
        return .init(action: { (target) in
            if state.count > 0 {
                for s in state {
                    target.setTitleColor(color, for: s)
                }
            }else{
                target.setTitleColor(color, for: .normal)
            }
        })
    }
    ///背景图片
    public static func bg(_ image:UIImage?, for state:UIControl.State = .normal) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.setBackgroundImage(image, for: state)
        })
    }
    ///背景图片
    public static func bg(_ imageNamed:String, for state:UIControl.State = .normal) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.setBackgroundImage(UIImage(named: imageNamed), for: state)
        })
    }
    ///背景颜色
    public static func bg(_ color:UIColor?, for state:UIControl.State = .normal) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            if state == .normal {
                target.backgroundColor = color
            }else{
                if let c = color {
                    let img = UIImage.easy.color(c)
                    target.setBackgroundImage(img, for: state)
                }else{
                    target.setBackgroundImage(nil, for: state)
                }
            }
        })
    }
    ///背景颜色
    public static func bg(rgb color:UInt32, for state:UIControl.State = .normal) -> EasyStyleSetting<TargetType> {
        return .bg(UIColor.easy.rgb( color), for: state)
    }
    ///对齐
    public static func align(_ align:UIControl.ContentHorizontalAlignment) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.contentHorizontalAlignment = align
        })
    }
    ///居中对齐
    public static var center: EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.contentHorizontalAlignment = .center
        })
    }
    ///最大显示行数
    public static func lines(_ lines:Int = 0) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.titleLabel?.numberOfLines = lines
        })
    }
    ///边距
    public static func edge(insets:UIEdgeInsets) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.contentEdgeInsets = insets
        })
    }
    ///边距
    public static func title(insets:UIEdgeInsets) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.titleEdgeInsets = insets
        })
    }
    ///边距
    public static func image(insets:UIEdgeInsets) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.imageEdgeInsets = insets
        })
    }
    ///字体最小比例
    public static func min(scale:CGFloat) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.titleLabel?.adjustsFontSizeToFitWidth = false
            target.titleLabel?.minimumScaleFactor = scale
        })
    }
    ///字体最小尺寸
    public static func min(size:CGFloat) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.titleLabel?.adjustsFontSizeToFitWidth = true
            target.titleLabel?.minimumScaleFactor = size
        })
    }
    ///选中
    public static func selected(_ selected:Bool = true) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.isSelected = selected
        })
    }
    ///选中
    public static func enabled(_ enabled:Bool = true) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.isEnabled = enabled
        })
    }
    ///是否自动适配图片点击(变灰)和不可用效果
    public static func adjusts(highlighted: Bool = true, disabled: Bool = false) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.adjustsImageWhenHighlighted = highlighted
            target.adjustsImageWhenDisabled = disabled
        })
    }
}

extension EasyStyleSetable where Self: UIButton {
    public static func easy(text: String? = nil, font: UIFont, color: UIColor?) -> Self {
        let o = self.init()
        o.setTitle(text, for: .normal)
        o.titleLabel?.font = font
        o.setTitleColor(color, for: .normal)
        return o
    }
}
