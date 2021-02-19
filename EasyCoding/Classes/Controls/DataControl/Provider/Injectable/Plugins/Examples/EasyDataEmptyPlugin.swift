//
//  EasyDataEmptyDecorator.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/30.
//
#if EASY_DATA

import UIKit

open class EasyDataEmptyPlugin<DataType>: EasyDataEmptyPluginBase<DataType> {
    ///要加载到的页面，若为空则加载到keywindow
    open weak var targetView: UIView?
    
    ///配置，可修改布局及加载隐藏动画
    public var config = EasyDataPluginConfig.shared.empty
    
    public lazy var emptyView: UIView = { self.config.viewBuilder?() ?? EasyDataPluginConfig.EmptyView() }()
    
    open override func load() {
        if let targetView = self.targetView {
            self.config.show(self.emptyView, at: targetView)
        }
    }
    
    open override func unload() {
        self.config.dismiss(self.emptyView)
    }
}
extension EasyDataPlugin {
    ///数据为空页面
    public static func empty(for view: UIView) -> EasyDataEmptyPlugin<DataType> {
        let plugin = EasyDataEmptyPlugin<DataType>()
        plugin.targetView = view
        return plugin
    }
}

#endif
