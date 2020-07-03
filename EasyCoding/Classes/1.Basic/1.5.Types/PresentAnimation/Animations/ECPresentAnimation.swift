//
//  ECPresentAnimation.swift
//  Alamofire
//
//  Created by JY_NEW on 2020/7/3.
//

import UIKit

///命名空间：放置所有呈现动画
public struct ECPresentAnimation {
    ///无动画
    public struct None: ECPresentAnimationType {
        public func show(view: UIView, completion: (() -> Void)?) {
            completion?()
        }
        
        public func dismiss(view: UIView, completion: (() -> Void)?) {
            completion?()
        }
        
    }
}
