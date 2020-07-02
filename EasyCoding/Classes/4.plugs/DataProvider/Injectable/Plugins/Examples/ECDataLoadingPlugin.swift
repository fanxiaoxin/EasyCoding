//
//  ECDataLoadingDecorator.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/30.
//

import UIKit

open class ECDataLoadingPlugin<DataType>: ECDataLoadingPluginBase<DataType> {
    ///要加载到的页面，若为空则加载到keywindow
    open weak var targetView: UIView?
    ///加载页
    open lazy var loadingView: UIView = {
        return ECLoadingView()
    }()
    
    ///配置，可修改布局及加载隐藏动画
    public let config = ECCustomControlConfig<UIView>(layouts: [.center])
    
    open override func load() {
        if let target = self.targetView ?? UIApplication.shared.keyWindow {
            if let superView = self.loadingView.superview, superView == target {
                self.loadingView.tag += 1
            }else{
                self.loadingView.tag = 0
                self.config.show(self.loadingView, at: target)
            }
        }
    }
    open override func unload() {
        if self.loadingView.tag == 0 {
            self.config.dismiss(self.loadingView)
        }else{
            self.loadingView.tag -= 1
        }
    }
}
