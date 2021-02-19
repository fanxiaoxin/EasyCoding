//
//  Number+EasyAdd.swift
//  EasyCoding
//
//  Created by Fanxx on 2018/3/23.
//  Copyright © 2018年 fanxx. All rights reserved.
//

import Foundation
import UIKit

public protocol EasyNumberExt: EasyExtension{
    
}

extension Int: EasyNumberExt { }
extension Double: EasyNumberExt { }
extension Float: EasyNumberExt { }
extension CGFloat: EasyNumberExt { }
extension Decimal: EasyNumberExt { }

extension EasyCoding where Base: EasyNumberExt {
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
    ///判断当前值是否在两个值中间
    public func isBetween(_ v1: Self.Base, _ v2: Self.Base) -> Bool {
        return v1.easy.objc.doubleValue < self.objc.doubleValue && v2.easy.objc.doubleValue > self.objc.doubleValue
    }
    ///若当前值在两个值中间则取当前值，若超过最大值则取最大值，小于最小值则取最小值
    public func between(_ v1: Self.Base, _ v2: Self.Base) -> Self.Base {
        let d1 = v1.easy.objc.doubleValue
        let d2 = v2.easy.objc.doubleValue
        let d = self.objc.doubleValue
        let max: Double, min: Double
        let m1: Self.Base, m2: Self.Base
        if d1 > d2 {
            max = d1
            min = d2
            m1 = v1
            m2 = v2
        }else{
            max = d2
            min = d1
            m1 = v2
            m2 = v1
        }
        if d > max {
            return m1
        }else if d < min {
            return m2
        }else{
            return self.base
        }
    }
}


extension EasyCoding where Base == CGFloat {
    ///单个像素值
    public static var pixel: CGFloat {
        return pixels(1)
    }
    ///计算像素值
    public static func pixels(_ p:CGFloat) -> CGFloat{
        return p / UIScreen.main.scale
    }
    ///自身为度数，转为角度
    public static func degreesToRadians(_ degrees: CGFloat) -> CGFloat {
        return degrees * CGFloat.pi / 180
    }
    ///自身角度，转为度数
    public static func radiansToDegrees(_ radians: CGFloat) -> CGFloat  {
        return radians * 180 / CGFloat.pi
    }
    ///自身为度数，转为角度
    public var degreesToRadians: CGFloat {
        return CGFloat.easy.degreesToRadians(self.base)
    }
    ///自身角度，转为度数
    public var radiansToDegrees: CGFloat {
        return CGFloat.easy.radiansToDegrees(self.base)
    }
}

extension EasyCoding where Base == Decimal {
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

extension EasyCoding where Base == UIEdgeInsets {
    public var leftRight: CGFloat {
        return self.base.left + self.base.right
    }
    public var topBottom: CGFloat {
        return self.base.top + self.base.bottom
    }
}
extension EasyCoding where Base == CGRect {
    ///上坐标，等于x
    public var top: CGFloat {
        return self.base.origin.y
    }
    ///左坐标，等于y
    public var left: CGFloat {
        return self.base.origin.x
    }
    ///下坐标，等于y + height
    public var bottom: CGFloat {
        return self.base.origin.y + self.base.size.height
    }
    ///右坐标，等于x + width
    public var right: CGFloat {
        return self.base.origin.x + self.base.size.width
    }
}

extension EasyCoding where Base == CGSize {
    ///返回高宽中比较大的值
    public var max: CGFloat {
        return Swift.max(self.base.width, self.base.height)
    }
    ///返回高宽中比较小的值
    public var min: CGFloat {
        return Swift.min(self.base.width, self.base.height)
    }
}

extension EasyCoding where Base == CGPoint {
    ///返回xy中比较大的值
    public var max: CGFloat {
        return Swift.max(self.base.x, self.base.y)
    }
    ///返回xy中比较小的值
    public var min: CGFloat {
        return Swift.min(self.base.x, self.base.y)
    }
}


