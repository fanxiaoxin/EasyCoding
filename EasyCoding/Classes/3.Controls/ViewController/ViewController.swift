//
//  ViewController.swift
//  ECKit
//
//  Created by Fanxx on 2019/4/19.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import UIKit
//import HandyJSON

open class ECViewController<PageType:UIView>: UIViewController, ECPageEventDelegate, ECViewControllerType {
    
    open var page: PageType!
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        if let title = (self.page as? ECPage)?.title {
            self.title = title
        }
        
        self.automaticallyAdjustsScrollViewInsets = !(self.navigationController?.isNavigationBarHidden ?? true)
        
        //添加键盘处理
        if let kc = (self.page as? ECPage)?.keyboardConstraint {
            let plug = ECViewControllerKeyboardAdaptPlug()
            plug.keyboardConstraint = kc
            self.easy.append(plug: plug)
        }
    }
    override open func loadView() {
        self.page = PageType()
        (self.page as? ECPage)?.eventDelegate = self
        self.view = self.page
    }
    ///设置进入该页面的权限
    open var preconditions: [ECViewControllerPrecondition]? { return nil }
    ///转让场景，不设置则默认Push
    open var segue: ECPresentSegue { return ECPresentSegue.push }
    ///关闭页面事件，Page中可直接用"Close"事件
    @objc open func onClose() {
        self.unload()
    }
}
