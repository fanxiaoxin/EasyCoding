//
//  UIView+EasyAdd.swift
//  EasyCoding
//
//  Created by Fanxx on 2018/3/23.
//  Copyright © 2018年 fanxx. All rights reserved.
//

import UIKit
import SnapKit

// MARK: 位置大小相关信息

extension EasyCoding where Base: UIView {
    ///判断刘海屏的安全区域
    public static var safeArea: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets ?? .zero
        } else {
            return .zero
        }
    }
    ///视图大小
    public var size: CGSize {
        return self.base.frame.size
    }
    ///视图宽度
    public var width: CGFloat {
        return self.base.frame.size.width
    }
    ///视图高度
    public var height: CGFloat {
        return self.base.frame.size.height
    }
    ///视图位置
    public var origin: CGPoint {
        return self.base.frame.origin
    }
    ///视图上边距
    public var top: CGFloat {
        return self.base.frame.origin.y
    }
    ///视图左边距
    public var left: CGFloat {
        return self.base.frame.origin.x
    }
    ///视图下边距
    public var bottom: CGFloat {
        return (self.base.superview?.bounds.size.height ?? 0) - self.base.frame.easy.bottom
    }
    ///视图右边距
    public var right: CGFloat {
        return (self.base.superview?.bounds.size.width ?? 0) - self.base.frame.easy.right
    }
}

// MARK: 位移动画等操作

extension EasyCoding where Base: UIView {
    ///因为直接设置锚点位置会乱，所以需要同步设置center以修正位置
    ///注意该方法只能在布局确定后才可以使用，或未布局完使用位置照样会乱
    public func anchor(_ anchor: CGPoint) {
        let view = self.base
        //若未加到父视图则无法生效
        view.superview?.layoutIfNeeded()
        
        let oldOrigin = view.frame.origin
        view.layer.anchorPoint = anchor
        let newOrigin = view.frame.origin
        
        let transition = CGPoint(x: newOrigin.x - oldOrigin.x, y: newOrigin.y - oldOrigin.y)
        
        view.center = .easy(view.center.x - transition.x, view.center.y - transition.y)
    }
    ///抖动动画
   public func shake() {
        UIView.animateKeyframes(withDuration: 1, delay: 0, options: UIView.KeyframeAnimationOptions.calculationModeLinear, animations: {
            let left = self.base.frame.origin.x
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2, animations: {
                self.base.frame.origin.x = left - 20
            })
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.32, animations: {
                self.base.frame.origin.x = left + 20
            })
            UIView.addKeyframe(withRelativeStartTime: 0.52, relativeDuration: 0.28, animations: {
                self.base.frame.origin.x = left - 15
            })
            UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.2, animations: {
                self.base.frame.origin.x = left
            })
        }, completion: nil)
    }
}

// MARK: 子视图相关操作：查找、定位、标记等

extension EasyCoding where Base: UIView {
    ///嵌套循环找到指定的View
    public func forEachAllSubviews<ViewType: UIView>(body: @escaping (ViewType) -> Void) {
        for view in self.base.subviews {
            if let v = view as? ViewType {
                body(v)
            }
            view.easy.forEachAllSubviews(body: body)
        }
    }
    ///查找第一个指定条件的视图(包含子视图的子视图)
    public func first<ViewType: UIView>(where body: (ViewType) -> Bool) -> UIView? {
        for view in self.base.subviews {
            if let v = view as? ViewType {
                if body(v) {
                    return v
                }
            }else{
                if let v = view.easy.first(where: body) {
                    return v
                }
            }
        }
        return nil
    }
    ///查找最后一个指定条件的视图(包含子视图的子视图)
    public func last<ViewType: UIView>(where body: (ViewType) -> Bool) -> UIView? {
        for view in self.base.subviews.reversed() {
            if let v = view as? ViewType {
                if body(v) {
                    return v
                }
            }else{
                if let v = view.easy.last(where: body) {
                    return v
                }
            }
        }
        return nil
    }
    ///清空子Viewigbw
    public func removeAllSubviews() {
        for view in self.base.subviews {
            view.removeFromSuperview()
        }
    }
    ///打标记
    public func tag(_ tag: Int) {
        self.setAssociated(object: NSNumber(integerLiteral: tag), key: Easy.key("View.Tag"))
    }
    ///获取当前标记
    public var tag: Int? {
        let value: NSNumber? = self.getAssociated(object: Easy.key("View.Tag"))
        return value?.intValue
    }
    ///获取指定标记的所有子视图(包含子视图的子视图), nil则返回自身
    public func viewsWithTag(_ tag: Int?) -> [UIView]? {
        if let value = tag {
            var views: [UIView] = []
            self.forEachAllSubviews { view in
                if view.easy.tag == value {
                    views.append(view)
                }
            }
            if views.count > 0 {
                return views
            }else{
                return nil
            }
        }else{
            return [self.base]
        }
    }
    ///获取指定标记的第一个子视图(包含子视图的子视图), nil则返回自身
    public func viewWithTag(_ tag: Int?) -> UIView? {
        if let value = tag {
            return self.first(where: { $0.easy.tag == value })
        }else{
            return self.base
        }
    }
    /*
    ///临时设置锚点并记录原始锚点，在reset(anchor:)方法可以重置原先的锚点
    public func set(anchor: CGPoint, for key: String) {
        //记录旧的锚点
        let easyKey = Easy.key("View.Anchor." + key)
        let orginAnchor = NSValue(cgPoint: self.base.layer.anchorPoint)
        self.setAssociated(object: orginAnchor, key: easyKey)
        self.anchor(anchor)
    }
    ///重置由set(anchor:,for:)方法设置前的锚点
    public func reset(anchor key: String) {
        //重设置旧的锚点
        let easyKey = Easy.key("View.Anchor." + key)
        if let orginAnchor: NSValue = self.getAssociated(object: easyKey) {
            self.anchor(orginAnchor.cgPointValue)
            self.removeAssociated(object: easyKey)
        }
    }
    ///临时设置锚点并记录原始锚点，在reset(transform:)方法可以重置原先的锚点
    public func set(transform: CGAffineTransform, for key: String) {
        //记录旧的锚点
        let easyKey = Easy.key("View.Transform." + key)
        let orginTransform = NSValue(cgAffineTransform: self.base.transform)
        self.setAssociated(object: orginTransform, key: easyKey)
        self.base.transform = transform
    }
    ///重置由set(transform:,for:)方法设置前的锚点
    public func reset(transform key: String) {
        //重设置旧的锚点
        let easyKey = Easy.key("View.Transform." + key)
        if let orginTransform: NSValue = self.getAssociated(object: easyKey) {
            self.base.transform = orginTransform.cgAffineTransformValue
            self.removeAssociated(object: easyKey)
        }
    }*/
}
/* 废弃，用StackView代替
extension EasyCoding where Base: UIView {
    func getVisibleConstraints() -> [NSLayoutConstraint]? {
        return self.getAssociated(object: "easyVisibleConstraints")
    }
    func setVisibleConstraints(_ value:[NSLayoutConstraint]?) {
        self.setAssociated(object: value, key: "easyVisibleConstraints")
    }
    public var isVisible: Bool {
        get {
            return !self.base.isHidden
        }
        set {
            self.set(visible: newValue)
        }
    }
    public func set(visible: Bool, direction: EasyDirection = .none, hierarchy: Int = 1) {
        if self.base.isHidden == visible {
            self.base.isHidden = !visible
            self.unsafeSet(visible: visible, direction: direction, hierarchy: hierarchy)
        }
    }
    private func unsafeSet(visible:Bool, direction:EasyDirection, hierarchy:Int) {
        if visible {
            if let constraints = self.getVisibleConstraints(), constraints.count > 0 {
                for constraint in constraints {
                    constraint.constant = constraint.easy.getVisibleConstant()
                }
            }
        }else{
            self.base.layoutIfNeeded()
            let frame = self.base.frame
            let dir = self.autoVisible(direction:direction,hierarchy:hierarchy)
            var constraints:[NSLayoutConstraint] = []
            var view = self.base.superview
            var h = hierarchy
            while let v = view,h > 0 {
                for constraint in v.constraints {
                    if self.setInvisible(constraint:constraint, frame:frame,direction:dir) {
                        constraints.append(constraint)
                    }
                }
                view = v.superview
                h -= 1
            }
            self.setVisibleConstraints(constraints)
        }
    }
    ///自动查找方向
    private func autoVisible(direction:EasyDirection,hierarchy:Int) -> EasyDirection {
        if direction == .none {
            var bottom = false
            var left = false
            var view = self.base.superview;
            var h = hierarchy
            while let v = view, h > 0 {
                for constraint in v.constraints {
                    let attribute:NSLayoutConstraint.Attribute?
                    if constraint.firstItem === self.base {
                        attribute = constraint.firstAttribute
                    }else if constraint.secondItem === self.base {
                        attribute = constraint.secondAttribute
                    }else{
                        attribute = nil
                    }
                    if let attr = attribute {
                        if !bottom && (
                            attr == .bottom ||
                                attr == .bottomMargin
                            ) {
                            bottom = true
                        }
                        if !left && (
                            attr == .left ||
                                attr == .leftMargin ||
                                attr == .leading ||
                                attr == .leadingMargin
                            ) {
                            left = true
                        }
                        if bottom && left {
                            return [.bottom, .left]
                        }
                    }
                }
                view = v.superview;
                h -= 1;
            }
            return [(bottom ? .bottom : .top), (left ? .left : .right)]
        }
        return direction;
    }
    private func setInvisible(constraint:NSLayoutConstraint, frame:CGRect,direction:EasyDirection) -> Bool {
        let attribute:NSLayoutConstraint.Attribute
        let prefix: CGFloat
        if constraint.firstItem === self.base {
            attribute = constraint.firstAttribute
            prefix = 1
        }else if constraint.secondItem === self.base {
            attribute = constraint.secondAttribute
            prefix = -1
        }else{
            return false
        }
        let cst = constraint
        switch (attribute) {
        case .top, .topMargin:
            if direction.contains(.bottom) {
                cst.easy.setVisibleConstant(constraint.constant)
                constraint.constant = prefix * frame.size.height;
                return true
            }
        case .left, .leftMargin, .leading, .leadingMargin:
            if direction.contains(.right) {
                cst.easy.setVisibleConstant(constraint.constant)
                constraint.constant = prefix * frame.size.width;
                return true
            }
        case .bottom, .bottomMargin:
            if direction.contains(.top) {
                cst.easy.setVisibleConstant(constraint.constant)
                constraint.constant = prefix * frame.size.height;
                return true
            }
        case .right, .rightMargin, .trailing, .trailingMargin:
            if direction.contains(.left) {
                cst.easy.setVisibleConstant(constraint.constant)
                constraint.constant = prefix * frame.size.width;
                return true
            }
        default:
            break;
        }
        return false
    }
    
    ///设置是否可见
    public func set(visible:Bool, direction:EasyDirection, animated: Bool, completion:(()->Void)? = nil) {
        let view = self.base
        if view.isHidden == visible {
            self.unsafeSet(visible: visible, direction: direction, hierarchy: 1)
            if animated {
                let alpha = view.alpha
                if visible {
                    view.alpha = 0
                    view.isHidden = false
                    UIView.animate(withDuration: 0.25, animations: {
                        view.superview?.layoutIfNeeded()
                        view.alpha = alpha
                    }) { (_) in
                        completion?()
                    }
                }else{
                    UIView.animate(withDuration: 0.25, animations: {
                        view.superview?.layoutIfNeeded()
                        view.alpha = 0
                    }) { (_) in
                        view.isHidden = true
                        view.alpha = alpha
                        completion?()
                    }
                }
            }else{
                view.isHidden = !visible
                completion?()
            }
        }
    }
}
extension EasyCoding where Base: NSLayoutConstraint {
    fileprivate func getVisibleConstant() -> CGFloat {
        return self.getAssociated(object: "easyVisibleConstant") ?? 0
    }
    fileprivate func setVisibleConstant(_ value:CGFloat) {
        self.setAssociated(object: value, key: "easyVisibleConstant")
    }
}
*/
