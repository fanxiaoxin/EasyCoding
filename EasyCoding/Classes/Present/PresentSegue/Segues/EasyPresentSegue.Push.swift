//
//  EasyPresentSegue_Push.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/3.
//

import UIKit

extension EasyPresentSegue {
    ///推送
    open class Push: EasyPresentSegue {
        public let isAnimated: Bool
        ///找不到UINavigationController时备用的场景
        public var segueForFailure: EasyPresentSegue? = nil
        public var isFailure:Bool = false
        public init(animated: Bool = true, segueForFailure: EasyPresentSegue? = nil) {
            self.isAnimated = animated
            self.segueForFailure = segueForFailure
            super.init()
        }
        open override func performAction(completion: (() -> Void)?) {
            if let s = self.source, let d = self.destination {
                self.isFailure = false
                if let nav = s.navigationController {
                    nav.pushViewController(d, animated: self.isAnimated)
                    completion?()
                } else if let tab = s as? UITabBarController, let nav = tab.selectedViewController as? UINavigationController {
                    nav.pushViewController(d, animated: self.isAnimated)
                    completion?()
                } else {
                    self.isFailure = true
                    self.segueForFailure?.performAction(completion: completion)
                }
            }
        }
        open override func unwindAction() {
            if self.isFailure {
                self.segueForFailure?.unwindAction()
            }else{
                self.destination?.navigationController?.popViewController(animated: self.isAnimated)
            }
        }
        open override func performNext(segue: EasyPresentSegueType, completion: (() -> Void)?) {
            if self.isFailure, let fs = self.segueForFailure {
                fs.performNext(segue: segue, completion: completion)
            }else{
                super.performNext(segue: segue, completion: completion)
            }
        }
    }
    ///带动画的推送
    public static var push: Push { return Push() }
    ///带动画的推送，若没有NavigationController则用Present
    public static var pushOrPresent: Push { return Push(animated: true, segueForFailure: .present) }
}
