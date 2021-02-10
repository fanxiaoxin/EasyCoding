//
//  UIColorExtension.swift
//  EasyCoding
//
//  Created by Fanxx on 2018/4/3.
//  Copyright © 2018年 fanxx. All rights reserved.
//

import UIKit

extension EasyCoding where Base: UIColor {
    ///生成虚线图
    public static func dottedLine(color:UIColor,size:CGSize,spacing:CGFloat) -> UIColor? {
        if let image = UIImage.easy.dottedLine(color: color, size: size, spacing: spacing) {
            return UIColor(patternImage: image)
        }
        return nil
    }
    public static func rgba(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1) -> UIColor {
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    public static func rgba(_ rgba: UInt32) -> UIColor {
        return UIColor(red: CGFloat((rgba & 0xFF000000) >> 24) / 255.0,
                    green:CGFloat((rgba & 0xFF0000) >> 16) / 255.0,
                    blue:CGFloat((rgba & 0xFF00) >> 8) / 255.0,
                    alpha:CGFloat(rgba & 0xFF) / 255.0)
    }
    public static func rgb(_ rgb: UInt32, alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
                    green:CGFloat((rgb & 0xFF00) >> 8) / 255.0,
                    blue:CGFloat(rgb & 0xFF) / 255.0,
                    alpha:alpha)
    }
    ///替换透明度
    public func alpha(_ value: CGFloat) -> UIColor {
        return self.base.withAlphaComponent(value)
    }
}
extension UIColor {
    public static func easy(_ rgb: UInt32) -> UIColor {
        return Self.easy.rgb(rgb)
    }
}
