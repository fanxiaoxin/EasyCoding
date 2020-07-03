//
//  Window.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/3.
//

import UIKit

extension ECPresentSegue {
    ///使用新窗口打开
    open class Window: ECPresentSegue {
        ///窗口级别
        public let level: UIWindow.Level
        ///是否keyWindow
        public let makeKey: Bool
        ///呈现动画
        open var animation: ECPresentAnimationType?
        ///窗口的样式设置
        open var windowStyles: [ECStyleSetting<UIWindow>] = []
        /// 使用新窗口打开
        /// - Parameters:
        ///   - level: 窗口级别
        ///   - makeKey: 是否keyWindow
        ///   - animation: 呈现动画
        public init(level: UIWindow.Level = .alert, makeKey: Bool = false, animation: ECPresentAnimationType? = nil) {
            self.level = level
            self.makeKey = makeKey
            self.animation = animation
            super.init()
        }
        ///获取动画，可重载
        open func animation(for view: UIView) -> ECPresentAnimationType? {
            return self.animation
        }
        ///获取用来做动画的视图，可重载
        open func viewForAnimation() -> UIView? {
            return self.destination?.view
        }
        open override func performAction(completion: (() -> Void)?) {
            if let d = self.destination {
                let window = d.easy.openWindow(level: level, makeKey: makeKey)
                if let view = self.viewForAnimation(), let am = self.animation(for: view) {
                    view.easy.show(animation: am, completion: completion)
                }else{
                    completion?()
                }
                self.windowStyles.forEach { (style) in
                    style.action(window)
                }
            }
        }
        open override func unwindAction() {
            weak var controller = self.destination
            if let view = self.viewForAnimation() {
                view.easy.dismiss {
                    controller?.easy.closeWindow()
                }
            }
        }
        open override func performNext(segue: ECPresentSegueType, completion: (() -> Void)?) {
            self.unwind()
             var s = segue
             s.source = self.source ?? s.source
             s.performAction(completion: completion)
        }
    }
}
