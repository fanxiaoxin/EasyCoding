//
//  StringAttributeShortcut.swift
//  Alamofire
//
//  Created by Fanxx on 2019/8/22.
//

import UIKit

extension ECStringAttribute {
    ///字体颜色
    public static func color(_ value: UIColor) -> ECStringAttribute {
        return .init(.foregroundColor, value)
    }
    ///字体颜色
    public static func color(rgb value: UInt32) -> ECStringAttribute {
        return .init(.foregroundColor, UIColor.easy.rgb(value))
    }
    ///背景颜色
    public static func bg(_ color: UIColor) -> ECStringAttribute {
        return .init(.backgroundColor, color)
    }
    ///背景颜色
    public static func bg(rgb value: UInt32) -> ECStringAttribute {
        return .init(.backgroundColor, UIColor.easy.rgb(value))
    }
    ///字体
    public static func font(_ value: UIFont) -> ECStringAttribute {
        return .init(.font, value)
    }
    ///字体
    public static func font(size: CGFloat) -> ECStringAttribute {
        return .init(.font, UIFont.systemFont(ofSize: size))
    }
    ///字体
    public static func boldFont(size: CGFloat) -> ECStringAttribute {
        return .init(.font, UIFont.boldSystemFont(ofSize: size))
    }
    ///是否包含连字符
    public static func ligature(_ value: Bool = true) -> ECStringAttribute {
        return .init(.ligature, value)
    }
    ///字距
    public static func kern(_ value: CGFloat) -> ECStringAttribute {
        return .init(.kern, value)
    }
    ///删除线
    public static func strikethrough(_ value: NSUnderlineStyle) -> ECStringAttribute {
        return .init(.strikethroughStyle, value)
    }
    ///下划线
    public static func underline(_ value: NSUnderlineStyle,_ color: UIColor? = nil) -> ECStringAttribute {
        var attr: [NSAttributedString.Key: Any] = [.underlineStyle: value]
        if let c = color {
            attr[.underlineColor] = c
        }
        return .init(attr)
    }
    ///下划线
    public static func underline(_ value: NSUnderlineStyle,rgb color: UInt32) -> ECStringAttribute {
        return underline(value, UIColor.easy.rgb(color))
    }
    ///描边
    public static func stroke(_ color: UIColor, _ width: CGFloat) -> ECStringAttribute {
        return .init([.strokeColor:color, .strokeWidth: width])
    }
    ///描边
    public static func stroke(rgb color: UInt32, _ width: CGFloat) -> ECStringAttribute {
        return .init([.strokeColor:UIColor.easy.rgb(color), .strokeWidth: width])
    }
    ///阴影
    public static func shadow(_ value: NSShadow) -> ECStringAttribute {
        return .init(.shadow, value)
    }
    ///阴影
    public static func shadow(offset: CGSize, radius: CGFloat, color: UIColor? = nil) -> ECStringAttribute {
        let shadow = NSShadow()
        shadow.shadowOffset = offset
        shadow.shadowBlurRadius = radius
        if let c = color {
            shadow.shadowColor = c
        }
        return .init(.shadow, shadow)
    }
    ///阴影
    public static func textEffect(_ style: NSAttributedString.TextEffectStyle) -> ECStringAttribute {
        return .init(.textEffect, style)
    }
    ///链接
    public static func link(_ url: NSURL) -> ECStringAttribute {
        return .init(.link, url)
    }
    ///链接
    public static func link(_ url: String) -> ECStringAttribute {
        return .init(.link, url)
    }
    ///基准线偏移
    public static func baseline(offset: CGFloat) -> ECStringAttribute {
        return .init(.baselineOffset, offset)
    }
    ///段落样式
    public static func paragraph(style: NSParagraphStyle) -> ECStringAttribute {
        return .init(.paragraphStyle, style)
    }
    ///附件
    public static func attachment(_ value: NSTextAttachment) -> ECStringAttribute {
        return .init(.attachment, value)
    }
    ///图片附件
    public static func image(_ image: UIImage, bounds:CGRect? = nil) -> ECStringAttribute {
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = bounds ?? CGRect(origin: .zero, size: image.size)
        return .init(.attachment, attachment)
    }
    ///附件
    public static func data(_ data: Data, type: String) -> ECStringAttribute {
        let attachment = NSTextAttachment(data: data, ofType: type)
        return .init(.attachment, attachment)
    }
    ///附件
    public static func file(_ fileWrapper: FileWrapper) -> ECStringAttribute {
        let attachment = NSTextAttachment()
        attachment.fileWrapper = fileWrapper
        return .init(.attachment, attachment)
    }
}
