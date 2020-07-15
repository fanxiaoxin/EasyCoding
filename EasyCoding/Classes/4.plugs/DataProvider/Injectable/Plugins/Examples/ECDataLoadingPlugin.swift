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
    
    ///配置，可修改布局及加载隐藏动画
    public var config = ECDataPluginConfig.shared.loading
    
    public lazy var loadingView: UIView = { self.config.viewBuilder?() ?? ECLoadingView() }()
    
    open override func load() {
        if let target = self.targetView ?? UIApplication.shared.keyWindow {
            if let superView = self.loadingView.superview, superView == target {
                self.loadingView.tag += 1
            }else{
                self.loadingView.tag = 0
                self.config.show(loadingView, at: target)
            }
        }
    }
    open override func unload() {
        if self.loadingView.tag == 0 {
            self.config.dismiss(loadingView)
        }else{
            self.loadingView.tag -= 1
        }
    }
}

extension ECDataPlugin {
    ///加载中显示加载页
    public static func loading(for view: UIView) -> ECDataLoadingPlugin<DataType> {
        let plugin = ECDataLoadingPlugin<DataType>()
        plugin.targetView = view
        return plugin
    }
}

