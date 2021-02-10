//
//  ImageViewStyle.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/7/15.
//

import UIKit

extension EasyStyleSetting where TargetType: UIImageView {
    ///图片
    public static func image(_ image:UIImage?, tint color: UIColor? = nil) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            if let c = color {
                target.image = image?.easy.by(tint: c)
            }else{
                target.image = image
            }
        })
    }
    ///图片
    public static func image(_ named:String, tint color: UIColor? = nil) -> EasyStyleSetting<TargetType> {
        return image(UIImage(named: named), tint: color)
    }
    ///图片
    public static func highlighted(image:UIImage?, tint color: UIColor? = nil) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            if let c = color {
                target.highlightedImage = image?.easy.by(tint: c)
            }else{
                target.highlightedImage = image
            }
        })
    }
    ///图片
    public static func highlighted(image named:String, tint color: UIColor? = nil) -> EasyStyleSetting<TargetType> {
        return highlighted(image:UIImage(named: named), tint: color)
    }
    
    ///图片变色
    public static func tint(color:UIColor) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.image = target.image?.easy.by(tint: color)
        })
    }
    ///图片变色
    public static func tint(rgbColor:UInt32) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.image = target.image?.easy.by(tint:UIColor.easy.rgb( rgbColor))
        })
    }
    
    ///图片变形
    public static func resizable(_ insets:UIEdgeInsets) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.image = target.image?.resizableImage(withCapInsets: insets)
            target.contentMode = .scaleToFill
        })
    }
    ///图片变形
    public static func resizable(_ top: CGFloat, _ left: CGFloat,_ bottom: CGFloat, _ right: CGFloat) -> EasyStyleSetting<TargetType> {
        return resizable(UIEdgeInsets(top: top, left: left, bottom: bottom, right: right))
    }
    ///旋转图片图片
    public static func rotate(_ degrees:CGFloat) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            if let img = target.image {
                let r = img.easy.by(rotate: degrees.easy.degreesToRadians)
                target.image = r
            }
        })
    }
    ///旋转图片图片
    public static func rotate(highlighted degrees:CGFloat) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            if let img = target.highlightedImage {
                let r = img.easy.by(rotate: degrees.easy.degreesToRadians)
                target.highlightedImage = r
            }
        })
    }
}
