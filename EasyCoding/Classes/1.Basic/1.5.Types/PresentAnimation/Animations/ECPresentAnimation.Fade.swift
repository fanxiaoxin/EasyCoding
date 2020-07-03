//
//  Fade.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/3.
//

import UIKit

extension ECPresentAnimation {
    ///淡入淡出动画
    public struct Fade: ECPresentAnimationType {
        ///动画时长
        public var duration: TimeInterval = 0.25
        public init() {
            
        }
        public func show(view: UIView, completion: (() -> Void)?) {
            view.alpha = 0
            UIView.animate(withDuration: self.duration, animations: {
                view.alpha = 1
            }) { (_) in
                completion?()
            }
        }
        
        public func dismiss(view: UIView, completion: (() -> Void)?) {
            UIView.animate(withDuration: self.duration, animations: {
                view.alpha = 0
            }) { (_) in
                completion?()
            }
        }
    }
}

extension EC.NamespaceImplement where Base: UIView {
    @discardableResult
    public func fade(completion: (() -> Void)? = nil) -> ECPresentAnimation.Fade {
        let animation = ECPresentAnimation.Fade()
        self.show(animation: animation, completion: completion)
        return animation
    }
}
