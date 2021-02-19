//
//  Popup.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/3.
//

import UIKit

extension EasyPresentSegue {
    ///Popup的场景
    open class Popup: Window {
        ///默认的Popup背景色
        public static var backgroundColor: UIColor = .init(white: 0, alpha: 0.4)
        ///可以指定要作动画的视图，显示起来会更精细
        public var contentView: UIView?
        public override init(level: UIWindow.Level = .alert, makeKey: Bool = false, animation: EasyPresentAnimationType? = EasyPresentAnimation.Popup()) {
            super.init(level: level, makeKey: makeKey, animation: animation)
            ///默认背景
            self.windowStyles = [.bg(Self.backgroundColor)]
        }
        open override func viewForAnimation() -> UIView? {
            return self.contentView ?? super.viewForAnimation()
        }
        open override func animation(for view: UIView) -> EasyPresentAnimationType? {
            if let animation = super.animation(for: view) {
                return animation
            }else{
                if view == self.contentView {
                    return self.defaultAnimation(for: view.superview ?? view)
                }else{
                    return self.defaultAnimation(for: view)
                }
            }
        }
        ///默认动画
        private func defaultAnimation(for view: UIView) -> EasyPresentAnimationType {
            ///如果贴着顶部则下划，贴着底部则上划，都贴或都不贴则中间弹出
            var top = false
            var bottom = false
            var left = false
            var right = false
            for cons in view.constraints {
                if cons.firstItem === view || cons.secondItem === view {
                    let a1 = cons.firstAttribute
                    let a2 = cons.secondAttribute
                    if (a1 == .top || a1 == .topMargin) && (a2 == .top || a2 == .topMargin) {
                        top = true
                    } else if (a1 == .bottom || a1 == .bottomMargin) && (a2 == .bottom || a2 == .bottomMargin) {
                        bottom = true
                    } else if (a1 == .left || a1 == .leftMargin) && (a2 == .left || a2 == .leftMargin) {
                        left = true
                    } else if (a1 == .right || a1 == .rightMargin) && (a2 == .right || a2 == .rightMargin) {
                        right = true
                    }
                }
            }
            if top != bottom && left == right {
                if top {
                    return EasyPresentAnimation.SlideOut(direction: .top)
                }else{
                    return EasyPresentAnimation.SlideOut(direction: .bottom)
                }
            } else if left != right && top == bottom {
                if left {
                    return EasyPresentAnimation.SlideOut(direction: .left)
                }else{
                    return EasyPresentAnimation.SlideOut(direction: .right)
                }
            }else{
                return EasyPresentAnimation.Popup()
            }
        }
    }
    ///Popup的常规场景
    public static var popup: Popup { return Popup() }
    ///Popup的常规场景
    public static func popup(alpha: CGFloat? = nil, animation: EasyPresentAnimationType? = nil) -> Popup {
        let p = Popup(animation: animation)
        if let a = alpha {
            p.windowStyles = [.bg(.init(white: 0, alpha: a))]
        }
        return p
    }
    ///Popup的常规场景
    public static func popup(content view: UIView, anchor: CGPoint? = nil) -> Popup {
        let p = popup(animation: EasyPresentAnimation.Popup(anchor: anchor))
        p.contentView = view
        return p
    }
}

extension EasyPresentSegue {
    ///Popup并则原先的卸载的场景
    open class PopupReplace: Popup {
        open override func performAction(completion: (() -> Void)?) {
            if let source = self.source, let segue = source.easy.currentSegue  {
                ///将上一级卸载
                source.easy.dismiss()
                ///将Source定位到再上一级
                self.source = segue.source
            }
            super.performAction(completion: completion)
        }
    }
    ///Popup并则原先的卸载的场景
    public static var popupReplace: PopupReplace { return PopupReplace() }
}
