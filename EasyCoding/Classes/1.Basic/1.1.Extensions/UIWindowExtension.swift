//
//  UIWindowExtension.swift
//  EasyCoding
//
//  Created by Fanxx on 2018/3/27.
//  Copyright © 2018年 fanxx. All rights reserved.
//

import UIKit

extension EC.NamespaceImplement where Base: UIWindow {
    ///当前显示的Controller(不包含Nav和Tab)
    public var currentViewController: UIViewController? {
        if var tg = self.base.rootViewController {
            while let c = self.uplayerViewController(from: tg) {
                tg = c
            }
            return tg
        }
        return nil
    }
    ///当前显示的Contrller的NavigationController
    public var currentNavigationController: UINavigationController? {
        return self.currentViewController?.navigationController
    }
    ///当前显示的Controller的TabbarController
    public var currentTabBarController: UITabBarController? {
        return self.currentViewController?.tabBarController
    }
    ///当前显示的页面，如有Navigation则返回Navigation，如有Tabbar则返回Tabbar，如都没则返回该页面
//    public var currentFrameController: UIViewController? {
//
//    }
    ///获取上一层Controller
    private func uplayerViewController(from controller:UIViewController) -> UIViewController? {
        if let c = controller.presentedViewController { return c }
        if let c = controller as? UITabBarController {
            if let sc = c.selectedViewController { return sc }
        }
        if let c = controller as? UINavigationController {
            if let sc = c.topViewController { return sc }
        }
        return nil
    }
}

///全局变量，用于存放打开的Window
var __easyCodingWindows: [UIWindow] = []
extension EC.NamespaceImplement where Base: UIWindow {
    ///当前程序的主窗口
    public static var mainWindow: UIWindow? {
        if let window = UIApplication.shared.delegate?.window {
            return window ?? UIApplication.shared.keyWindow
        }
        return nil
    }
    ///一般和mainWindow是同一个
    public static var keyWindow: UIWindow? {
        return UIApplication.shared.keyWindow
    }
    ///当前最顶层的window
    public static var topWindow: UIWindow? {
        var top : UIWindow? = nil
        for w in UIApplication.shared.windows {
            if w.windowLevel.rawValue >= (top?.windowLevel.rawValue ?? 0) {
                top = w
            }
        }
        return top
    }
    //显示窗口
    public func show(){
        __easyCodingWindows.append(self.base)
        self.base.isHidden = false
    }
    //关闭窗口
    public func close(){
        self.base.isHidden = true
        if let index = __easyCodingWindows.firstIndex(of: self.base) {
            __easyCodingWindows.remove(at: index)
        }
    }
    //关闭所有通过EasyCoding打开的窗口
    public static func closeAll(){
        for window in __easyCodingWindows {
            window.isHidden = true
        }
        __easyCodingWindows.removeAll()
    }
}

extension EC.NamespaceImplement where Base: UIViewController {
    ///通过打开新的Window显示viewController
    public func showWindow(level:UIWindow.Level = UIWindow.Level.alert) -> UIWindow{
        let window = UIWindow(frame:UIScreen.main.bounds)
        window.windowLevel = level
        window.rootViewController = self.base
        window.easy.show()
        return window
    }
    ///关闭通过showWindow打开的窗口
    public func closeWindow(){
        self.base.view.window?.easy.close()
    }
}

extension EC.NamespaceImplement where Base: UIView {
    ///通过打开新的Window显示view
    public func showWindow(level:UIWindow.Level = UIWindow.Level.alert) -> UIWindow {
        let controller = UIViewController()
        controller.view = self.base
        return controller.easy.showWindow(level: level)
    }
    ///关闭通过showWindow打开的窗口
    public func closeWindow(){
        self.base.window?.easy.close()
    }
}
