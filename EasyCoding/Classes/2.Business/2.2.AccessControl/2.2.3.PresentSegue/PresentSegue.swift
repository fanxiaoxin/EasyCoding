//
//  PresentSegue.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/6/4.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import UIKit

open class ECPresentSegue: ECPresentSegueType {
    
    public weak var source: UIViewController?
    public weak var destination: UIViewController?
    
    open func performAction(completion: (() -> Void)?) {
        
    }
    open func unwindAction() {
        
    }
    open func performNext(segue: ECPresentSegueType, completion: (() -> Void)?) {
        segue.performAction(completion: completion)
    }
}

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

extension ECPresentSegue {
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
                        cs[i].easy.set(currentSegue: segue)
                    }
                }
                if cs.count > 0 {
                    let segue = Push(animated: self.isAnimated)
                    segue.source = s
                    segue.destination = cs[0]
                    cs[0].easy.set(currentSegue: segue)
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

extension ECPresentSegue {
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

extension ECPresentSegue {
    ///从下往上弹
    public class Present: ECPresentSegue {
        public let isAnimated: Bool
        public init(animated: Bool = true) {
            self.isAnimated = animated
            super.init()
        }
        open override func performAction(completion: (() -> Void)?) {
            if let s = self.source, let d = self.destination {
                s.present(d, animated: self.isAnimated, completion: completion)
            }
        }
        public override func unwindAction() {
            self.destination?.dismiss(animated: self.isAnimated, completion: nil)
        }
    }
    public static var present: Present { return Present() }
}

extension ECPresentSegue {
    ///附加到TabbarController上
    public class TabBar: ECPresentSegue {
        public let icon: UIImage?
        public let selectedIcon: UIImage?
        public init(icon:UIImage?,selected: UIImage?) {
            self.icon = icon
            self.selectedIcon = selected
            super.init()
        }
        public convenience init(iconNamed:String,selectedNamed: String?) {
            let icon = UIImage(named: iconNamed)?.withRenderingMode(.alwaysOriginal)
            let selected: UIImage?
            if let s = selectedNamed {
                selected = UIImage(named: s)?.withRenderingMode(.alwaysOriginal)
            }else{
                selected = nil
            }
            self.init(icon: icon, selected: selected)
        }
        
        open override func performAction(completion: (() -> Void)?) {
            if let tab = self.source as? UITabBarController, let d = self.destination {
                if var cs = tab.viewControllers {
                    cs.append(d)
                    tab.viewControllers = cs
                }else{
                    tab.viewControllers = [d]
                }
                let index = tab.viewControllers!.count - 1
                tab.tabBar.items![index].image = icon
                tab.tabBar.items![index].selectedImage = selectedIcon
                completion?()
            }
        }
        public override func unwindAction() {
            if let d = self.destination, let tab = d.tabBarController {
                if let index = tab.viewControllers?.firstIndex(of: d) {
                    tab.viewControllers!.remove(at: index)
                }
            }
        }
    }
}

extension ECPresentSegue {
    ///指定加载到某个View，这个场景只能由调用方使用，因为被调用方无法固定要加载的View
    public class Content: ECPresentSegue {
        public let view: UIView
        public init(view: UIView) {
            self.view = view
            super.init()
        }
        open override func performAction(completion: (() -> Void)?) {
            if let s = self.source, let d = self.destination {
                s.addChild(d)
                self.view.addSubview(d.view)
                d.view.snp.makeConstraints { (make) in
                    make.edges.equalTo(view)
                }
                completion?()
            }
        }
        public override func unwindAction() {
            self.destination?.view.removeFromSuperview()
            self.destination?.removeFromParent()
        }
    }
}

extension ECPresentSegue {
    ///使用新窗口打开
    public class Window: ECPresentSegue {
        public let level: UIWindow.Level
        public init(level: UIWindow.Level = .alert) {
            self.level = level
            super.init()
        }
        open override func performAction(completion: (() -> Void)?) {
            if let d = self.destination {
                d.easy.showWindow(level: level)
                completion?()
            }
        }
        public override func unwindAction() {
            self.destination?.easy.closeWindow()
        }
        public override func performNext(segue: ECPresentSegueType, completion: (() -> Void)?) {
            self.unwind()
            segue.performAction(completion: completion)
        }
    }
}
