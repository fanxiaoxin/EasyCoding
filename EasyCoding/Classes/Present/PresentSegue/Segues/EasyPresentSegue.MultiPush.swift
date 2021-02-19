//
//  EasyPresentSegue_MutliPush.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/3.
//

import UIKit

extension EasyPresentSegue {
    ///推送同个Controller
    public class MultiPush: Push {
        public let controllers: [UIViewController]
        public init(controllers: [UIViewController], animated: Bool = true) {
            self.controllers = controllers
            super.init(animated: animated)
        }
        open override func performAction(completion: (() -> Void)?) {
            if let s = self.source, let d = self.destination {
                var cs = controllers
                cs.append(d)
                //先设置要插在中间的Segue，防止退出后异常
                if cs.count > 1 {
                    for i in 1..<cs.count {
                        let segue = Push(animated: self.isAnimated)
                        segue.source = cs[i-1]
                        segue.destination = cs[i]
                        cs[i].easy.currentSegue(segue)
                    }
                }
                if cs.count > 0 {
                    let segue = Push(animated: self.isAnimated)
                    segue.source = s
                    segue.destination = cs[0]
                    cs[0].easy.currentSegue(segue)
                }
                if let nav = s.navigationController {
                    nav.easy.push(cs, animated: self.isAnimated)
                    completion?()
                } else if let tab = s as? UITabBarController, let nav = tab.selectedViewController as? UINavigationController {
                    nav.easy.push(cs, animated: self.isAnimated)
                    completion?()
                }
            }
        }
    }
}
