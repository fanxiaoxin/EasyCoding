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
public enum ECViewLayoutCompare {
    ///等于
    case equal
    ///小于等于
    case lessThanOrEqual
    ///大于等于
    case greatherThanOrEqual
}
extension ConstraintMakerExtendable {
    func compare(_ c: ECViewLayoutCompare, _ other: ConstraintRelatableTarget) -> ConstraintMakerEditable {
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
public enum ECViewLayout {
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
    indirect case parent(ECViewLayout)
    ///小于等于
    indirect case less(ECViewLayout)
    ///大于等于
    indirect case greather(ECViewLayout)
    ///组合约束，用于自定义
    case set([ECViewLayout])
    ///自定义
    case custom(apply:(UIView, UIView)->Void)
    
    ///优先级
    indirect case priority(ECViewLayout, ConstraintPriority)
    ///优先级
    public func priority(_ value: ConstraintPriority) -> ECViewLayout {
        return .priority(self, value)
    }
    ///更新约束
    indirect case update(ECViewLayout)
    ///更新约束
    public func update() -> ECViewLayout {
        return .update(self)
    }
    ///指定页面布局
    indirect case with(UIView,ECViewLayout)
    ///指定页面布局
    public func with(_ view: UIView) -> ECViewLayout {
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
extension ECViewLayout {
    ///若是负值需要取反
    func reverse(_ compare: ECViewLayoutCompare) -> ECViewLayoutCompare {
        switch compare {
        case .greatherThanOrEqual: return .lessThanOrEqual
        case .lessThanOrEqual: return .greatherThanOrEqual
        default: return compare
        }
    }
    ///应用约束
    public func apply(to v1: UIView, with v2: UIView, compare: ECViewLayoutCompare = .equal, priority: ConstraintPriority? = nil, isUpdating: Bool = false) {
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
extension Array where Element == ECViewLayout {
    ///应用约束
    public func apply(to v1: UIView, with v2: UIView) {
        self.forEach { $0.apply(to: v1, with: v2) }
    }
    ///应用约束
    public func apply(to views: [UIView]) {
        self.forEach { $0.apply(to: views) }
    }
}

extension EC.NamespaceImplement where Base: UIView {
    @discardableResult
    public func layout(_ view: UIView, _ layouts:ECViewLayout...) -> Self {
        layouts.apply(to: self.base, with: view)
        return self
    }
    @discardableResult
    public func layout(_ layouts:ECViewLayout...) -> Self {
        layouts.apply(to: self.base.superview ?? self.base, with: self.base)
        return self
    }
}
/*
extension EC.NamespaceImplement where Base == [UIView] {
    @discardableResult
    public func layout(_ layout:ECViewLayout...) -> Self {
        layout.apply(to: self.base)
        return self
    }
}*/
extension EC.NamespaceArrayImplement where Element: UIView {
    @discardableResult
    public func layout(_ layout:ECViewLayout...) -> Self {
        layout.apply(to: self.base)
        return self
    }
}
///快捷方式
extension ECViewLayout {
    ///相对高度
    public static var height: ECViewLayout { return .relativeHeight(0, 1) }
    ///相对宽度
    public static var width: ECViewLayout { return .relativeWidth(0, 1) }
    
    ///绝对高度
    public static func height(_ v:CGFloat) -> ECViewLayout { return .absoluteHeight(v) }
    ///绝对宽度
    public static func width(_ v:CGFloat) -> ECViewLayout { return .absoluteWidth(v) }
    ///绝对大小
    public static func size(_ widthHeight:CGFloat) -> ECViewLayout { return .set([.absoluteWidth(widthHeight), .absoluteHeight(widthHeight)]) }
    ///绝对大小
    public static func size(_ width:CGFloat, _ height: CGFloat) -> ECViewLayout { return .set([.absoluteWidth(width), .absoluteHeight(height)]) }
    
    ///左左
    public static var left: ECViewLayout { return .left(0) }
    ///右右
    public static var right: ECViewLayout { return .right(0) }
    ///上上
    public static var top: ECViewLayout { return .top(0) }
    ///下下
    public static var bottom: ECViewLayout { return .bottom(0) }
    
    ///上基线对齐
    public static var firstBaseline: ECViewLayout { return .firstBaseline(0) }
    ///下基线对齐
    public static var lastBaseline: ECViewLayout { return .lastBaseline(0) }
    
    ///左右
    public static var leftRight: ECViewLayout { return .leftRight(0) }
    ///右左
    public static var rightLeft: ECViewLayout { return .rightLeft(0) }
    ///上下
    public static var topBottom: ECViewLayout { return .topBottom(0) }
    ///下上
    public static var bottomTop: ECViewLayout { return .bottomTop(0) }
    
    ///水平居中
    public static var centerX: ECViewLayout { return .centerX(0) }
    ///竖直居中
    public static var centerY: ECViewLayout { return .centerY(0) }
    ///居中
    public static var center: ECViewLayout { return .center(0,0) }
    ///居中
    public static func center(_ v:CGPoint) -> ECViewLayout { return .center(v.x, v.y) }
    
    ///水平边距
    public static func marginX(_ v:CGFloat) -> ECViewLayout { return .marginX(v, v) }
    ///竖直边距
    public static func marginY(_ v:CGFloat) -> ECViewLayout { return .marginY(v, v) }
    ///水平边距
    public static var marginX: ECViewLayout { return .marginX(0,0) }
    ///竖直边距
    public static var marginY: ECViewLayout { return .marginY(0,0) }
    
    ///边距(水平，竖直)
    public static func margin(_ vx:CGFloat, _ vy:CGFloat) -> ECViewLayout { return .margin(vy, vx, vy, vx) }
    ///边距
    public static func margin(_ v:CGFloat) -> ECViewLayout { return .margin(v, v, v, v) }
    ///四周贴边
    public static var margin: ECViewLayout { return .margin(0,0,0,0) }
    ///边距
    public static func margin(_ edge:UIEdgeInsets) -> ECViewLayout { return .margin(edge.top, edge.left, edge.bottom, edge.right) }
}
//父视图扩展
extension ECViewLayout {
    ///父视图水平边距
    public static func paddingX(_ left:CGFloat, _ right: CGFloat) -> ECViewLayout { return .parent(.marginX(left, right)) }
    ///父视图竖直边距
    public static func paddingY(_ top:CGFloat, _ bottom: CGFloat) -> ECViewLayout { return .parent(.marginY(top, bottom)) }
    ///父视图水平边距
    public static func paddingX(_ v:CGFloat) -> ECViewLayout { return .parent(.marginX(v, v)) }
    ///父视图竖直边距
    public static func paddingY(_ v:CGFloat) -> ECViewLayout { return .parent(.marginY(v, v)) }
    ///父视图水平边距
    public static var paddingX: ECViewLayout { return .parent(.marginX(0,0)) }
    ///父视图竖直边距
    public static var paddingY: ECViewLayout { return .parent(.marginY(0,0)) }
    
}
