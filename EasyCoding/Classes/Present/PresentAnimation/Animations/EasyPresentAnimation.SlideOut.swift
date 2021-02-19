//
//  EasyPresentAnimation.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/3.
//

import UIKit

extension EasyPresentAnimation {
    ///普通的侧滑动画
    public struct SlideOut: EasyPresentAnimationType {
        ///侧滑起始位置，默认为下，none无效
        public let direction: EasyDirection
        ///动画时长
        public var duration: TimeInterval = EasyPresentAnimation.defaultAnimationDuration
        public init(direction: EasyDirection? = nil) {
            self.direction = direction ?? .bottom
        }
        func transform(for view: UIView) -> CGAffineTransform {
            view.superview?.layoutIfNeeded()
            let frame = view.frame
            let superSize = view.superview?.bounds.size ?? UIScreen.main.bounds.size
            switch direction {
            case .top: return .init(translationX: 0, y: -frame.origin.y - frame.size.height)
            case .left: return .init(translationX: -frame.origin.x - frame.size.width, y: 0)
            case .right: return .init(translationX: superSize.width, y: 0)
            default: return .init(translationX: 0, y: superSize.height)
            }
        }
        public func show(view: UIView, completion: (() -> Void)?) {
            view.alpha = 0
            view.transform = self.transform(for: view)
            UIView.animate(withDuration: self.duration, animations: {
                view.alpha = 1
                view.transform = .identity
            }) { (_) in
                completion?()
            }
        }
        
        public func dismiss(view: UIView, completion: (() -> Void)?) {
            UIView.animate(withDuration: self.duration, animations: {
                view.transform = self.transform(for: view)
                view.alpha = 0
            }) { (_) in
                completion?()
            }
        }
    }
}


extension EasyCoding where Base: UIView {
    @discardableResult
    public func slideOut(direction: EasyDirection? = nil, completion: (() -> Void)? = nil) -> EasyPresentAnimation.SlideOut {
        let animation = EasyPresentAnimation.SlideOut(direction: direction)
        self.show(animation: animation, completion: completion)
        return animation
    }
}
