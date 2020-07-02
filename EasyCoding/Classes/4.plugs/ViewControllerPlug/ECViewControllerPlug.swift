//
//  ECViewControllerPlug.swift
//  ECKit
//
//  Created by Fanxx on 2019/6/4.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import UIKit
import JRSwizzle

///ViewController插件
@objc public protocol ECViewControllerPlug {
    weak var controller: UIViewController? { get set }
    @objc optional func beforeViewDidLoad()
    @objc optional func beforeViewWillAppear(_ animated: Bool)
    @objc optional func beforeViewDidAppear(_ animated: Bool)
    @objc optional func beforeViewWillDisappear(_ animated: Bool)
    @objc optional func beforeViewDidDisappear(_ animated: Bool)
    @objc optional func beforeViewWillLayoutSubviews()
    @objc optional func beforeViewDidLayoutSubviews()
    @objc optional func afterViewDidLoad()
    @objc optional func afterViewWillAppear(_ animated: Bool)
    @objc optional func afterViewDidAppear(_ animated: Bool)
    @objc optional func afterViewWillDisappear(_ animated: Bool)
    @objc optional func afterViewDidDisappear(_ animated: Bool)
    @objc optional func afterViewWillLayoutSubviews()
    @objc optional func afterViewDidLayoutSubviews()
}

fileprivate var __viewControllerPlugsSwizzled: Bool = false
fileprivate let __viewControllerPlugsSwizzleLock: Int = 0
///切换插件方法
func __fxSwizzleViewControllerPlugs() {
    ///如果未切换过方法，则切换
    if !__viewControllerPlugsSwizzled {
        objc_sync_enter(__viewControllerPlugsSwizzleLock)
        if !__viewControllerPlugsSwizzled {
            __viewControllerPlugsSwizzled = true
            try? UIViewController.jr_swizzleMethod(#selector(UIViewController.viewDidLoad), withMethod: #selector(UIViewController.fxPlugsViewDidLoad))
            try? UIViewController.jr_swizzleMethod(#selector(UIViewController.viewWillAppear(_:)), withMethod: #selector(UIViewController.fxPlugsViewWillAppear(_:)))
            try? UIViewController.jr_swizzleMethod(#selector(UIViewController.viewDidAppear(_:)), withMethod: #selector(UIViewController.fxPlugsViewDidAppear(_:)))
            try? UIViewController.jr_swizzleMethod(#selector(UIViewController.viewWillDisappear(_:)), withMethod: #selector(UIViewController.fxPlugsViewWillDisappear(_:)))
            try? UIViewController.jr_swizzleMethod(#selector(UIViewController.viewDidDisappear(_:)), withMethod: #selector(UIViewController.fxPlugsViewDidDisappear(_:)))
            try? UIViewController.jr_swizzleMethod(#selector(UIViewController.viewWillLayoutSubviews), withMethod: #selector(UIViewController.fxPlugsViewWillLayoutSubviews))
            try? UIViewController.jr_swizzleMethod(#selector(UIViewController.viewDidLayoutSubviews), withMethod: #selector(UIViewController.fxPlugsViewDidLayoutSubviews))
        }
        objc_sync_exit(__viewControllerPlugsSwizzleLock)
    }
}
extension EC.NamespaceImplement where Base: UIViewController {
    public var plugs: [ECViewControllerPlug]? {
        return self.getAssociated(object:"fxPlugs")
    }
    public func plugs(_ plugs:[ECViewControllerPlug]?) {
        plugs?.forEach({ $0.controller = self.base })
        self.setAssociated(object: plugs, key: "fxPlugs")
        __fxSwizzleViewControllerPlugs()
    }
    ///在保留现有插件的基础上添加插件
    public func append(plug:ECViewControllerPlug) {
        self.append(plugs: [plug])
    }
    ///在保留现有插件的基础上添加插件
    public func append(plugs:[ECViewControllerPlug]) {
        if var ps = self.plugs {
            ps.append(contentsOf: plugs)
            self.plugs(ps)
        }else{
            self.plugs(plugs)
        }
    }
}
var __fxViewControllerPlugs: [ECViewControllerPlug]?
extension EC.NamespaceImplement where Base: UIViewController {
    public static var plugs: [ECViewControllerPlug]? {
        return __fxViewControllerPlugs
        
    }
    ///静态的Plugs中的controller是空的，需要注意
    public static func plugs(_ plugs:[ECViewControllerPlug]?) {
        __fxViewControllerPlugs = plugs
        __fxSwizzleViewControllerPlugs()
    }
    ///在保留现有插件的基础上添加插件
    public static func append(plug:ECViewControllerPlug) {
        self.append(plugs: [plug])
    }
    ///在保留现有插件的基础上添加插件
    public static func append(plugs:[ECViewControllerPlug]) {
        if var ps = self.plugs {
            ps.append(contentsOf: plugs)
            self.plugs(ps)
        }else{
            self.plugs(plugs)
        }
    }
}

extension UIViewController {
    
    @objc func fxPlugsViewDidLoad() {
        UIViewController.easy.plugs?.forEach({ $0.beforeViewDidLoad?() })
        self.easy.plugs?.forEach({ $0.beforeViewDidLoad?() })
        self.fxPlugsViewDidLoad()
        self.easy.plugs?.forEach({ $0.afterViewDidLoad?() })
        UIViewController.easy.plugs?.forEach({ $0.afterViewDidLoad?() })
    }
    @objc func fxPlugsViewWillAppear(_ animated: Bool) {
        UIViewController.easy.plugs?.forEach({ $0.beforeViewWillAppear?(animated) })
        self.easy.plugs?.forEach({ $0.beforeViewWillAppear?(animated) })
        self.fxPlugsViewWillAppear(animated)
        self.easy.plugs?.forEach({ $0.afterViewWillAppear?(animated) })
        UIViewController.easy.plugs?.forEach({ $0.afterViewWillAppear?(animated) })
    }
    @objc func fxPlugsViewDidAppear(_ animated: Bool) {
        UIViewController.easy.plugs?.forEach({ $0.beforeViewDidAppear?(animated) })
        self.easy.plugs?.forEach({ $0.beforeViewDidAppear?(animated) })
        self.fxPlugsViewDidAppear(animated)
        self.easy.plugs?.forEach({ $0.afterViewDidAppear?(animated) })
        UIViewController.easy.plugs?.forEach({ $0.afterViewDidAppear?(animated) })
    }
    @objc func fxPlugsViewWillDisappear(_ animated: Bool) {
        UIViewController.easy.plugs?.forEach({ $0.beforeViewWillDisappear?(animated) })
        self.easy.plugs?.forEach({ $0.beforeViewWillDisappear?(animated) })
        self.fxPlugsViewWillDisappear(animated)
        self.easy.plugs?.forEach({ $0.afterViewWillDisappear?(animated) })
        UIViewController.easy.plugs?.forEach({ $0.afterViewWillDisappear?(animated) })
    }
    @objc func fxPlugsViewDidDisappear(_ animated: Bool) {
        UIViewController.easy.plugs?.forEach({ $0.beforeViewDidDisappear?(animated) })
        self.easy.plugs?.forEach({ $0.beforeViewDidDisappear?(animated) })
        self.fxPlugsViewDidDisappear(animated)
        self.easy.plugs?.forEach({ $0.afterViewDidDisappear?(animated) })
        UIViewController.easy.plugs?.forEach({ $0.afterViewDidDisappear?(animated) })
    }
    @objc func fxPlugsViewWillLayoutSubviews() {
        UIViewController.easy.plugs?.forEach({ $0.beforeViewWillLayoutSubviews?() })
        self.easy.plugs?.forEach({ $0.beforeViewWillLayoutSubviews?() })
        self.fxPlugsViewWillLayoutSubviews()
        self.easy.plugs?.forEach({ $0.afterViewWillLayoutSubviews?() })
        UIViewController.easy.plugs?.forEach({ $0.afterViewWillLayoutSubviews?() })
    }
    @objc func fxPlugsViewDidLayoutSubviews() {
        UIViewController.easy.plugs?.forEach({ $0.beforeViewDidLayoutSubviews?() })
        self.easy.plugs?.forEach({ $0.beforeViewDidLayoutSubviews?() })
        self.fxPlugsViewDidLayoutSubviews()
        self.easy.plugs?.forEach({ $0.afterViewDidLayoutSubviews?() })
        UIViewController.easy.plugs?.forEach({ $0.afterViewDidLayoutSubviews?() })
    }
}
