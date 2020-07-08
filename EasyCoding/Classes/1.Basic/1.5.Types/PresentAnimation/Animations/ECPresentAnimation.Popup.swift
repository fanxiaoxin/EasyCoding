//
//  ECPresentAnimation.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/3.
//

import UIKit

extension ECPresentAnimation {
    ///普通的弹窗动画
    public struct Popup: ECPresentAnimationType {
        ///弹窗的起止位置从0至1，默认居中(0.5, 0.5)
        public let anchor: CGPoint
        ///起始缩放，默认从0.01到1
        public let startScale: CGPoint
        ///动画时长
        public var duration: TimeInterval = ECConstant.animationDuration
        public init(anchor: CGPoint? = nil, startScale: CGPoint? = nil) {
            self.anchor = anchor ?? .easy(0.5)
            self.startScale = startScale ?? .easy(0.01)
        }
        public func show(view: UIView, completion: (() -> Void)?) {
            let orginAnchor = view.layer.anchorPoint
            view.easy.anchor(self.anchor)
            
            view.alpha = 0
            view.transform = .init(scaleX: self.startScale.x, y: self.startScale.y)
            UIView.animate(withDuration: self.duration, animations: {
                view.alpha = 1
                view.transform = .identity
            }) { (_) in
                view.easy.anchor(orginAnchor)
                completion?()
            }
        }
        
        public func dismiss(view: UIView, completion: (() -> Void)?) {
            let orginAnchor = view.layer.anchorPoint
            view.easy.anchor(self.anchor)
            UIView.animate(withDuration: self.duration, animations: {
                view.transform = .init(scaleX: self.startScale.x, y: self.startScale.y)
                view.alpha = 0
            }) { (_) in
                //重设置旧的锚点
                view.easy.anchor(orginAnchor)
                completion?()
            }
        }
    }
}

extension EC.NamespaceImplement where Base: UIView {
    @discardableResult
    public func popup(anchor: CGPoint? = nil, completion: (() -> Void)? = nil) -> ECPresentAnimation.Popup {
        let animation = ECPresentAnimation.Popup(anchor: anchor)
        self.show(animation: animation, completion: completion)
        return animation
    }
    ///通过打开新的Window显示view
    @discardableResult
    public func popupWindow(anchor: CGPoint? = nil, completion: (() -> Void)? = nil) -> UIWindow{
        let animation = ECPresentAnimation.Popup(anchor: anchor)
        return self.showWindow(animation: animation, completion: completion)
    }
}


extension EC.NamespaceImplement where Base: UIViewController {
    ///通过打开新的Window显示viewController
    @discardableResult
    public func popupWindow(anchor: CGPoint? = nil, completion: (() -> Void)? = nil) -> UIWindow{
        let animation = ECPresentAnimation.Popup(anchor: anchor)
        return self.showWindow(animation: animation, completion: completion)
    }
}
