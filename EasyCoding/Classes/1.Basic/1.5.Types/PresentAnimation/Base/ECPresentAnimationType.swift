//
//  ECPresentAnimationType.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/3.
//

import UIKit

///用来定制加载卸载动画，仅实现动画效果，不管添加删除view
public protocol ECPresentAnimationType {
    ///显示
    func show(view: UIView, completion: (() -> Void)?)
    ///隐藏
    func dismiss(view: UIView, completion: (() -> Void)?)
}

extension EC.NamespaceImplement where Base: UIView {
    ///通过指定的动画显示
    public func show(animation: ECPresentAnimationType, completion: (() -> Void)? = nil) {
        //因为如果动画为struct的话，存进去无法强制转换回协议，所以只存dismiss方法为block则可以取回来
        let dismiss: (UIView, (() -> Void)?) -> Void = animation.dismiss
        self.setAssociated(object: dismiss, key: EC.key("PresentAnimationType.Dismiss"))
        self.base.isHidden = false
        animation.show(view: self.base, completion: completion)
    }
    ///通过show(animation:)方法指定的动画关闭
    public func dismiss(completion: (() -> Void)? = nil) {
        if let dismiss: (UIView, (() -> Void)?) -> Void = self.getAssociated(object: EC.key("PresentAnimationType.Dismiss")){
            weak var view = self.base
            dismiss(self.base) {
                view?.isHidden = true
                completion?()
            }
            self.removeAssociated(object: EC.key("PresentAnimationType.Dismiss"))
        }else{
            self.base.isHidden = true
            completion?()
        }
    }
}

extension EC.NamespaceImplement where Base: UIViewController {
     ///通过打开新的Window显示viewController
    @discardableResult
    public func showWindow(level:UIWindow.Level = UIWindow.Level.alert, makeKey:Bool = false, animation: ECPresentAnimationType? = nil, completion: (() -> Void)? = nil) -> UIWindow{
        let window = self.openWindow(level: level, makeKey: makeKey)
        if let am = animation {
            self.base.view.easy.show(animation: am, completion: completion)
        }else{
            completion?()
        }
        return window
    }
    ///关闭通过showWindow打开的窗口
    public func dismissWindow(completion: (() -> Void)? = nil){
        weak var controller = self.base
        self.base.view.easy.dismiss {
            controller?.easy.closeWindow()
            completion?()
        }
    }
}

extension EC.NamespaceImplement where Base: UIView {
     ///通过打开新的Window显示viewController
    @discardableResult
    public func showWindow(level:UIWindow.Level = UIWindow.Level.alert, makeKey:Bool = false, useOwnFrame: Bool = true, animation: ECPresentAnimationType? = nil, completion: (() -> Void)? = nil) -> UIWindow{
        let window = self.openWindow(level: level, makeKey: makeKey, useOwnFrame: useOwnFrame)
        if let am = animation {
            self.show(animation: am, completion: completion)
        }else{
            completion?()
        }
        return window
    }
    ///关闭通过showWindow打开的窗口
    public func dismissWindow(completion: (() -> Void)? = nil){
        weak var view = self.base
        self.dismiss {
            view?.easy.closeWindow()
            completion?()
        }
    }
}
