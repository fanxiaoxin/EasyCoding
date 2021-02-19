//
//  Window.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/3.
//

import UIKit

extension EasyPresentSegue {
    ///使用新窗口打开
    open class Window: EasyPresentSegue {
        ///窗口级别
        public let level: UIWindow.Level
        ///是否keyWindow
        public let makeKey: Bool
        ///呈现动画
        open var animation: EasyPresentAnimationType?
        ///执行动画
        private var animationGroup = EasyPresentAnimation.Group()
        ///窗口的样式设置
        open var windowStyles: [EasyStyleSetting<UIWindow>] = []
        /// 使用新窗口打开
        /// - Parameters:
        ///   - level: 窗口级别
        ///   - makeKey: 是否keyWindow
        ///   - animation: 呈现动画
        public init(level: UIWindow.Level = .alert, makeKey: Bool = false, animation: EasyPresentAnimationType? = nil) {
            self.level = level
            self.makeKey = makeKey
            self.animation = animation
            super.init()
        }
        ///获取动画，可重载
        open func animation(for view: UIView) -> EasyPresentAnimationType? {
            return self.animation
        }
        ///获取动画，可重载
        open func animation(for window: UIWindow) -> EasyPresentAnimationType? {
            return EasyPresentAnimation.FadeColor()
        }
        ///获取用来做动画的视图，可重载
        open func viewForAnimation() -> UIView? {
            return self.destination?.view
        }
        open override func performAction(completion: (() -> Void)?) {
            if let d = self.destination {
                let window = d.easy.openWindow(level: level, makeKey: makeKey)
                self.windowStyles.forEach { (style) in
                    style.action(window)
                }
                self.animationGroup.animations.removeAll()
                if let am = self.animation(for: window) {
                    animationGroup.animations.append((tag: nil, delay: 0, aniamtion: am))
                }
                if let view = self.viewForAnimation(), let am = self.animation(for: view) {
                    view.easy.tag(1001)
                    animationGroup.animations.append((tag: 1001, delay: 0, aniamtion: am))
                }
                animationGroup.show(view: window, completion: completion)
            }
        }
        open override func unwindAction() {
            weak var controller = self.destination
            if let window = controller?.view.window {
                self.animationGroup.dismiss(view: window) {
                    controller?.easy.closeWindow()
                }
            }
        }
        open override func performNext(segue: EasyPresentSegueType, completion: (() -> Void)?) {
            self.unwind()
             var s = segue
             s.source = self.source ?? s.source
             s.performAction(completion: completion)
        }
    }
}
