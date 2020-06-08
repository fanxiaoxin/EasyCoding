//
//  MFMessageBox.swift
//  ManageFinances
//
//  Created by Fanxx on 16/7/7.
//  Copyright © 2016年 YinChengPai. All rights reserved.
//

import UIKit

open class ECMessageBox {
    public static var alertStylesheet: ECAlertController.Stylesheet = .default
    ///自定义视图弹出框
    open class func alert(title: String? = nil,view:UIView,buttons:[String],destructiveIndex:Int? = nil,action:((Int)->Bool)? = nil) {
        let window = UIWindow(frame:UIScreen.main.bounds)
        window.windowLevel = UIWindow.Level.alert
        let controller = ECAlertController()
        controller.stylesheet = alertStylesheet
        controller.title = title
        controller.contentView = view
        controller.buttons = buttons
        controller.destructiveIndex = destructiveIndex
        controller.action = { i in
            var cls = true
            if let c = action?(i) {
                cls = c
            }
            if let wd = controller.view.window, cls {
                wd.easy.close()
            }
        }
        window.rootViewController = controller
        window.easy.show()
    }
}

extension ECMessageBox {
    ///挂在导航条下面并且自动消失的提示框
    open class func curtain(_ view:UIView,completion:(()->Void)? = nil) {
        if let topController = UIWindow.easy.mainWindow?.easy.currentViewController {
            let controller = ECCurtainController()
            controller.contentView = view
            controller.completion = completion
            controller.show(topController)
        }
    }
}

extension ECMessageBox {
    ///在target的外面套一层View加边距
    class func wrapView(_ target:UIView,leftRight:CGFloat,topBottom:CGFloat) -> UIView {
        return self.wrapView(target, edge: UIEdgeInsets(top: topBottom, left: leftRight, bottom: topBottom, right: leftRight),minHeight: nil)
    }
    ///在target的外面套一层View加边距
    class func wrapView(_ target:UIView,edge:UIEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5),minHeight:CGFloat? = 98) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.addSubview(target)
        target.snp.makeConstraints { (make) in
            make.edges.equalTo(view).inset(edge)
        }
        if let height = minHeight {
            view.snp.makeConstraints({ (make) in
                make.height.greaterThanOrEqualTo(height)
            })
        }
        return view
    }
}
