//
//  Fade.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/3.
//

import UIKit

extension EasyPresentAnimation {
    ///淡入淡出动画
    public struct Fade: EasyPresentAnimationType {
        ///动画时长
        public var duration: TimeInterval =  EasyPresentAnimation.defaultAnimationDuration
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
    ///淡入淡出颜色动画
    public struct FadeColor: EasyPresentAnimationType {
        ///动画时长
        public var duration: TimeInterval =  EasyPresentAnimation.defaultAnimationDuration
        ///起始颜色，默认透明，为nil则代表使用原本颜色
        public var from: UIColor?
        ///结束颜色，默认原本颜色，为nil则代表使用原本颜色
        public var to: UIColor?
        public init(from: UIColor? = .clear, to: UIColor? = nil) {
            self.from = from
            self.to = to
        }
        public func show(view: UIView, completion: (() -> Void)?) {
            let color = self.to ?? view.backgroundColor
            view.backgroundColor = self.from
            UIView.animate(withDuration: self.duration, animations: {
                view.backgroundColor = color
            }) { (_) in
                completion?()
            }
        }
        
        public func dismiss(view: UIView, completion: (() -> Void)?) {
            //不设回背景色，否则可能会会闪过一下设背景色的不良体验
//            let color = self.to ?? view.backgroundColor
            UIView.animate(withDuration: self.duration, animations: {
                view.backgroundColor = self.from
            }) { (_) in
                completion?()
//                view.backgroundColor = color
            }
        }
    }
}

extension EasyCoding where Base: UIView {
    @discardableResult
    public func fade(completion: (() -> Void)? = nil) -> EasyPresentAnimation.Fade {
        let animation = EasyPresentAnimation.Fade()
        self.show(animation: animation, completion: completion)
        return animation
    }
}
