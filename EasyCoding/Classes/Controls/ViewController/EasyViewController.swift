//
//  ViewController.swift
//  EasyKit
//
//  Created by Fanxx on 2019/4/19.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import UIKit
//import HandyJSON

open class EasyViewController<PageType:UIView>: UIViewController, EasyPageEventDelegate, EasyViewControllerType {
    
    open var page: PageType!
    open var keyboardAdapter: EasyViewControllerKeyboardAdapter?

    override open func viewDidLoad() {
        super.viewDidLoad()
        
        if self.title == nil, let title = (self.page as? EasyPage)?.title {
            self.title = title
        }
        
        self.automaticallyAdjustsScrollViewInsets = !(self.navigationController?.isNavigationBarHidden ?? true)
        
        //添加键盘处理
        if let kc = (self.page as? EasyPage)?.keyboardConstraint {
            let keyboardAdapter = EasyViewControllerKeyboardAdapter()
            keyboardAdapter.keyboardConstraint = kc
            keyboardAdapter.controller = self
            self.keyboardAdapter = keyboardAdapter
        }
    }
    override open func loadView() {
        self.page = PageType()
        (self.page as? EasyPage)?.eventDelegate = self
        self.view = self.page
    }
    ///设置进入该页面的权限
    open var preconditions: [EasyViewControllerCondition]? { return nil }
    ///转让场景，不设置则默认Push
    open var segue: EasyPresentSegue { return EasyPresentSegue.push }
    ///关闭页面事件，Page中可直接用"Close"事件
    @objc open func onClose() {
        self.unload()
    }
}
