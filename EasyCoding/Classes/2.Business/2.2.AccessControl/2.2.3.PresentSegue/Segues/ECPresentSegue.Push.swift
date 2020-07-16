//
//  ECPresentSegue_Push.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/3.
//

import UIKit

extension ECPresentSegue {
    ///推送
    open class Push: ECPresentSegue {
        public let isAnimated: Bool
        public init(animated: Bool = true) {
            self.isAnimated = animated
            super.init()
        }
        open override func performAction(completion: (() -> Void)?) {
            if let s = self.source, let d = self.destination {
                if let nav = s.navigationController {
                    nav.pushViewController(d, animated: self.isAnimated)
                    completion?()
                } else if let tab = s as? UITabBarController, let nav = tab.selectedViewController as? UINavigationController {
                    nav.pushViewController(d, animated: self.isAnimated)
                    completion?()
                }
            }
        }
        open override func unwindAction() {
            self.destination?.navigationController?.popViewController(animated: self.isAnimated)
        }
    }
    ///带动画的推送
    public static var push: Push { return Push() }
}
