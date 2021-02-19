//
//  Replace.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/3.
//

import UIKit

extension EasyPresentSegue {
    ///用NavigationController替换当前页面
    public class Replace: Push {
        ///要替换的层级，0为不替换，默认为1
        public let count: Int
        public init(count: Int = 1, animated: Bool = true) {
            self.count = count
            super.init(animated: animated)
        }
        open override func performAction(completion: (() -> Void)?) {
            if let s = self.source, let d = self.destination {
                if let nav = s.navigationController {
                    nav.easy.replace(d, level: count, animated: self.isAnimated)
                    completion?()
                } else if let tab = s as? UITabBarController, let nav = tab.selectedViewController as? UINavigationController {
                    nav.easy.replace(d, level: count, animated: self.isAnimated)
                    completion?()
                }
            }
        }
    }
    ///用NavigationController替换当前页面
    public static var replace: Replace { return Replace() }
}
