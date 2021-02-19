//
//  EasyPresentAnimation.swift
//  Alamofire
//
//  Created by JY_NEW on 2020/7/3.
//

import UIKit

///命名空间：放置所有呈现动画
public struct EasyPresentAnimation {
    ///默认动画时长
    public static let defaultAnimationDuration: TimeInterval = 0.25
    ///无动画
    public struct None: EasyPresentAnimationType {
        public func show(view: UIView, completion: (() -> Void)?) {
            completion?()
        }
        
        public func dismiss(view: UIView, completion: (() -> Void)?) {
            completion?()
        }
        
    }
}
extension EasyPresentAnimationType {
    ///动画时长默认
    public var duration: TimeInterval { return EasyPresentAnimation.defaultAnimationDuration }
}
