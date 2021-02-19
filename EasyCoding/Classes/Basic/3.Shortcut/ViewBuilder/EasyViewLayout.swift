//
//  ViewLayout.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/5/30.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import UIKit
import SnapKit

///约束值比较
public enum EasyViewLayoutCompare {
    ///等于
    case equal
    ///小于等于
    case lessThanOrEqual
    ///大于等于
    case greatherThanOrEqual
}
extension ConstraintMakerExtendable {
    func compare(_ c: EasyViewLayoutCompare, _ other: ConstraintRelatableTarget) -> ConstraintMakerEditable {
        switch c {
        case .equal:
            return self.equalTo(other)
        case .lessThanOrEqual:
            return self.lessThanOrEqualTo(other)
        case .greatherThanOrEqual:
            return self.greaterThanOrEqualTo(other)
        }
    }
}

///视图约束
public enum EasyViewLayout {
    ///相对高度(差额，比例)
    case relativeHeight(CGFloat, CGFloat)
    ///相对宽度(差额，比例)
    case relativeWidth(CGFloat, CGFloat)
    
    ///自身高度
    case absoluteHeight(CGFloat)
    ///自身宽度
    case absoluteWidth(CGFloat)
    
    ///左-左
    case left(CGFloat)
    ///右-右
    case right(CGFloat)
    ///上-上
    case top(CGFloat)
    ///下-下
    case bottom(CGFloat)
    
    ///上基线
    case firstBaseline(CGFloat)
    ///线基线
    case lastBaseline(CGFloat)
    
    ///左-右
    case leftRight(CGFloat)
    ///右-左
    case rightLeft(CGFloat)
    ///上-下
    case topBottom(CGFloat)
    ///下-上
    case bottomTop(CGFloat)
    
    ///水平居中
    case centerX(CGFloat)
    ///竖直居中
    case centerY(CGFloat)
    ///居中
    case center(CGFloat, CGFloat)
    
    ///左-左，右-右
    case marginX(CGFloat,CGFloat)
    ///上-上，下-下
    case marginY(CGFloat,CGFloat)
    ///上-上，左-左，下-下，右-右
    case margin(CGFloat,CGFloat,CGFloat,CGFloat)
    
    ///针对父视图做约束
    indirect case parent(EasyViewLayout)
    ///小于等于
    indirect case less(EasyViewLayout)
    ///大于等于
    indirect case greather(EasyViewLayout)
    ///组合约束，用于自定义
    case set([EasyViewLayout])
    ///自定义
    case custom(apply:(UIView, UIView)->Void)
    
    ///优先级
    indirect case priority(EasyViewLayout, ConstraintPriority)
    ///优先级
    public func priority(_ value: ConstraintPriority) -> EasyViewLayout {
        return .priority(self, value)
    }
    ///更新约束
    indirect case update(EasyViewLayout)
    ///更新约束
    public func update() -> EasyViewLayout {
        return .update(self)
    }
    ///指定页面布局
    indirect case with(UIView,EasyViewLayout)
    ///指定页面布局
    public func with(_ view: UIView) -> EasyViewLayout {
        return .with(view, self)
    }
}

extension ConstraintMakerEditable {
    @discardableResult
    func ec_priority(_ value: ConstraintPriority?) -> ConstraintMakerFinalizable? {
        if let v = value {
            return self.priority(v)
        } else {
            return nil
        }
    }
}
extension EasyViewLayout {
    ///若是负值需要取反
    func reverse(_ compare: EasyViewLayoutCompare) -> EasyViewLayoutCompare {
        switch compare {
        case .greatherThanOrEqual: return .lessThanOrEqual
        case .lessThanOrEqual: return .greatherThanOrEqual
        default: return compare
        }
    }
    ///应用约束
    public func apply(to v1: UIView, with v2: UIView, compare: EasyViewLayoutCompare = .equal, priority: ConstraintPriority? = nil, isUpdating: Bool = false) {
        var abort = true
        switch self {
        case let .set(layout): layout.forEach({ $0.apply(to: v1, with: v2, compare: compare, priority: priority) })
        case let .custom(apply: apply): apply(v1, v2)
        case let .parent(layout):
            if let sp = v1.superview {
                layout.apply(to: sp, with: v2, compare: compare, priority: priority, isUpdating: isUpdating)
            }
        case let .less(layout):
            layout.apply(to: v1, with: v2, compare: .lessThanOrEqual, priority: priority, isUpdating: isUpdating)
        case let .greather(layout):
            layout.apply(to: v1, with: v2, compare: .greatherThanOrEqual, priority: priority, isUpdating: isUpdating)
        case let .priority(layout, value):
            layout.apply(to: v1, with: v2, compare: compare, priority: value, isUpdating: isUpdating)
        case let .update(layout):
            layout.apply(to: v1, with: v2, compare: compare, priority: priority, isUpdating: true)
        case let .with(view, layout):
            layout.apply(to: v2, with: view, compare: compare, priority: priority, isUpdating: isUpdating)
        default: abort = false
        }
        if abort {
            return
        }
        let maker = isUpdating ? v2.snp.updateConstraints : v2.snp.makeConstraints
        maker { (make) in
            switch self {
            ///相对高度
            case let .relativeHeight(os, m): make.height.compare(compare, v1).offset(os).multipliedBy(m).ec_priority(priority)
            ///相对宽度
            case let .relativeWidth(os, m): make.width.compare(compare, v1).offset(os).multipliedBy(m).ec_priority(priority)
            ///绝对高度
            case let .absoluteHeight(v): make.height.compare(compare, v).ec_priority(priority)
            ///绝对宽度
            case let .absoluteWidth(v): make.width.compare(compare, v).ec_priority(priority)
            ///左-左
            case let .left(v): make.left.compare(compare, v1).offset(v).ec_priority(priority)
            ///右-右
            case let .right(v): make.right.compare(reverse(compare), v1).offset(-v).ec_priority(priority)
            ///上-上
            case let .top(v): make.top.compare(compare, v1).offset(v).ec_priority(priority)
            ///下-下
            case let .bottom(v): make.bottom.compare(reverse(compare), v1).offset(-v).ec_priority(priority)
            
            ///上基线
            case let .firstBaseline(v): make.firstBaseline.compare(reverse(compare), v1).offset(-v).ec_priority(priority)
            ///下基线
            case let .lastBaseline(v): make.lastBaseline.compare(reverse(compare), v1).offset(-v).ec_priority(priority)
                
            ///左-右
            case let .leftRight(v): make.right.compare(reverse(compare), v1.snp.left).offset(-v).ec_priority(priority)
            ///右-左
            case let .rightLeft(v): make.left.compare(compare, v1.snp.right).offset(v).ec_priority(priority)
            ///上-下
            case let .topBottom(v): make.bottom.compare(reverse(compare), v1.snp.top).offset(-v).ec_priority(priority)
            ///下-上
            case let .bottomTop(v): make.top.compare(compare, v1.snp.bottom).offset(v).ec_priority(priority)
                
            ///水平居中
            case let .centerX(v): make.centerX.compare(compare, v1).offset(v).ec_priority(priority)
            ///竖直居中
            case let .centerY(v): make.centerY.compare(compare, v1).offset(v).ec_priority(priority)
            //居中
            case let .center(x, y):
                make.centerX.compare(compare, v1).offset(x).ec_priority(priority)
                make.centerY.compare(compare, v1).offset(y).ec_priority(priority)
                
            ///左-左，右-右
            case let .marginX(left,right):
                make.left.compare(compare, v1).offset(left).ec_priority(priority)
                make.right.compare(reverse(compare), v1).offset(-right).ec_priority(priority)
            ///上-上，下-下
            case let .marginY(top,bottom):
                make.top.compare(compare, v1).offset(top).ec_priority(priority)
                make.bottom.compare(reverse(compare), v1).offset(-bottom).ec_priority(priority)
            ///上-上，左-左，下-下，右-右
            case let .margin(top,left,bottom,right):
                make.edges.compare(compare, v1).inset(UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)).ec_priority(priority)
            default: break
            }
        }
    }
    ///应用约束
    public func apply(to views: [UIView]) {
        if views.count < 1 {
            return
        }
        switch self {
        case let .parent(layout):
            layout.apply(to: views.map({ $0.superview ?? $0 }))
            return
        default: break
        }
        for i in 0..<views.count - 1 {
            self.apply(to: views[i], with: views[i + 1])
        }
    }
}
extension Array where Element == EasyViewLayout {
    ///应用约束
    public func apply(to v1: UIView, with v2: UIView) {
        self.forEach { $0.apply(to: v1, with: v2) }
    }
    ///应用约束
    public func apply(to views: [UIView]) {
        self.forEach { $0.apply(to: views) }
    }
}

extension EasyCoding where Base: UIView {
    @discardableResult
    public func layout(_ view: UIView, _ layouts:EasyViewLayout...) -> Self {
        layouts.apply(to: self.base, with: view)
        return self
    }
    @discardableResult
    public func layout(_ layouts:EasyViewLayout...) -> Self {
        layouts.apply(to: self.base.superview ?? self.base, with: self.base)
        return self
    }
}
extension Easy.NamespaceArrayImplement where Element: UIView {
    @discardableResult
    public func layout(_ layout:EasyViewLayout...) -> Self {
        layout.apply(to: self.base)
        return self
    }
}
///快捷方式
extension EasyViewLayout {
    ///相对高度
    public static var height: EasyViewLayout { return .relativeHeight(0, 1) }
    ///相对宽度
    public static var width: EasyViewLayout { return .relativeWidth(0, 1) }
    ///相对大小
    public static var size: EasyViewLayout { return .set([.relativeWidth(0, 1), .relativeHeight(0, 1)]) }
    
    ///绝对高度
    public static func height(_ v:CGFloat) -> EasyViewLayout { return .absoluteHeight(v) }
    ///绝对宽度
    public static func width(_ v:CGFloat) -> EasyViewLayout { return .absoluteWidth(v) }
    ///绝对大小
    public static func size(_ widthHeight:CGFloat) -> EasyViewLayout { return .set([.absoluteWidth(widthHeight), .absoluteHeight(widthHeight)]) }
    ///绝对大小
    public static func size(_ width:CGFloat, _ height: CGFloat) -> EasyViewLayout { return .set([.absoluteWidth(width), .absoluteHeight(height)]) }
    
    ///左左
    public static var left: EasyViewLayout { return .left(0) }
    ///右右
    public static var right: EasyViewLayout { return .right(0) }
    ///上上
    public static var top: EasyViewLayout { return .top(0) }
    ///下下
    public static var bottom: EasyViewLayout { return .bottom(0) }
    
    ///上基线对齐
    public static var firstBaseline: EasyViewLayout { return .firstBaseline(0) }
    ///下基线对齐
    public static var lastBaseline: EasyViewLayout { return .lastBaseline(0) }
    
    ///左右
    public static var leftRight: EasyViewLayout { return .leftRight(0) }
    ///右左
    public static var rightLeft: EasyViewLayout { return .rightLeft(0) }
    ///上下
    public static var topBottom: EasyViewLayout { return .topBottom(0) }
    ///下上
    public static var bottomTop: EasyViewLayout { return .bottomTop(0) }
    
    ///水平居中
    public static var centerX: EasyViewLayout { return .centerX(0) }
    ///竖直居中
    public static var centerY: EasyViewLayout { return .centerY(0) }
    ///居中
    public static var center: EasyViewLayout { return .center(0,0) }
    ///居中
    public static func center(_ v:CGPoint) -> EasyViewLayout { return .center(v.x, v.y) }
    
    ///水平边距
    public static func marginX(_ v:CGFloat) -> EasyViewLayout { return .marginX(v, v) }
    ///竖直边距
    public static func marginY(_ v:CGFloat) -> EasyViewLayout { return .marginY(v, v) }
    ///水平边距
    public static var marginX: EasyViewLayout { return .marginX(0,0) }
    ///竖直边距
    public static var marginY: EasyViewLayout { return .marginY(0,0) }
    
    ///边距(水平，竖直)
    public static func margin(_ vx:CGFloat, _ vy:CGFloat) -> EasyViewLayout { return .margin(vy, vx, vy, vx) }
    ///边距
    public static func margin(_ v:CGFloat) -> EasyViewLayout { return .margin(v, v, v, v) }
    ///四周贴边
    public static var margin: EasyViewLayout { return .margin(0,0,0,0) }
    ///边距
    public static func margin(_ edge:UIEdgeInsets) -> EasyViewLayout { return .margin(edge.top, edge.left, edge.bottom, edge.right) }
}
//父视图扩展
extension EasyViewLayout {
    ///父视图水平边距
    public static func paddingX(_ left:CGFloat, _ right: CGFloat) -> EasyViewLayout { return .parent(.marginX(left, right)) }
    ///父视图竖直边距
    public static func paddingY(_ top:CGFloat, _ bottom: CGFloat) -> EasyViewLayout { return .parent(.marginY(top, bottom)) }
    ///父视图水平边距
    public static func paddingX(_ v:CGFloat) -> EasyViewLayout { return .parent(.marginX(v, v)) }
    ///父视图竖直边距
    public static func paddingY(_ v:CGFloat) -> EasyViewLayout { return .parent(.marginY(v, v)) }
    ///父视图水平边距
    public static var paddingX: EasyViewLayout { return .parent(.marginX(0,0)) }
    ///父视图竖直边距
    public static var paddingY: EasyViewLayout { return .parent(.marginY(0,0)) }
    
}
