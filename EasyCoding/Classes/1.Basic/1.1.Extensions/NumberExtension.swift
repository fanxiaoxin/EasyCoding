//
//  Number+FXAdd.swift
//  FXKit
//
//  Created by Fanxx on 2018/3/23.
//  Copyright © 2018年 fanxx. All rights reserved.
//

import Foundation
import UIKit

public protocol ECNumberExt: EC.NamespaceDefine{
    
}

extension Int: ECNumberExt { }
extension Double: ECNumberExt { }
extension Float: ECNumberExt { }
extension CGFloat: ECNumberExt { }
extension Decimal: ECNumberExt { }

extension EC.NamespaceImplement where Base: ECNumberExt {
    ///转成objc对象
    public var objc: NSNumber {
        return self.base as! NSNumber
    }
    ///千分符表示法
    public func thousandthDescription(_ decimalLength:Int = 0) -> String {
        let formatter = NumberFormatter()
        let format = NSMutableString(string:"###,##0")
        if (decimalLength > 0) {
            format.append(".")
            for _ in 0...decimalLength - 1 {
                format.append("0")
            }
        }
        formatter.positiveFormat = format as String?
        return formatter.string(from: self.objc) ?? (decimalLength > 0 ? "0" + format.substring(from: 7) : "0")
    }
    ///格式化字符串
    public func description(_ format:String) -> String {
        let formatter = NumberFormatter()
        formatter.positiveFormat = format
        return formatter.string(from: self.objc) ?? self.objc.description
    }
    public func between(_ v1: Self, _ v2: Self) -> Bool {
        return v1.objc.doubleValue < self.objc.doubleValue && v2.objc.doubleValue > self.objc.doubleValue
    }
}


extension CGFloat: EC.NamespaceDefine { }
extension EC.NamespaceImplement where Base == CGFloat {
    public static var pixel: CGFloat {
        return pixels(1)
    }
    ///计算像素值
    public static func pixels(_ p:CGFloat) -> CGFloat{
        return p / UIScreen.main.scale
    }
}

extension Decimal: EC.NamespaceDefine { }
extension EC.NamespaceImplement where Base == Decimal {
    public func round(_ scale:Int, mode:NSDecimalNumber.RoundingMode) -> Decimal {
        var result = Decimal()
        var source = self.base
        NSDecimalRound(&result, &source, scale, mode)
        return result
    }
}

extension CGSize {
    public static func easy(_ widthHeight: CGFloat) -> CGSize {
        return CGSize(width: widthHeight, height: widthHeight)
    }
    public static func easy(_ width: CGFloat, _ height: CGFloat) -> CGSize {
        return CGSize(width: width, height: height)
    }
}
extension CGPoint {
    public static func easy(_ xy: CGFloat) -> CGPoint {
        return CGPoint(x: xy, y: xy)
    }
    public static func easy(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
        return CGPoint(x: x, y: y)
    }
    public static func easy(x: CGFloat = 0, y: CGFloat = 0) -> CGPoint {
        return CGPoint(x: x, y: y)
    }
}
extension CGRect {
    public static func easy(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    public static func easy(x: CGFloat = 0, y: CGFloat = 0, width: CGFloat, height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    public static func easy(_ width: CGFloat,_ height: CGFloat) -> CGRect {
        return CGRect(x: 0, y: 0, width: width, height: height)
    }
    public static func easy(_ size: CGSize) -> CGRect {
        return CGRect(origin: .zero, size: size)
    }
}
extension UIEdgeInsets {
    public static func easy(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> UIEdgeInsets {
        return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    public static func easy(x: CGFloat = 0, y: CGFloat = 0) -> UIEdgeInsets {
        return UIEdgeInsets(top: y, left: x, bottom: y, right: x)
    }
    public static func easy(_ xy: CGFloat = 0) -> UIEdgeInsets {
        return UIEdgeInsets(top: xy, left: xy, bottom: xy, right: xy)
    }
}
