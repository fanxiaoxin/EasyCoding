//
//  EasyDataErrorDecorator.swift
//  Alamofire
//
//  Created by JY_NEW on 2020/6/30.
//
#if EASY_DATA

import UIKit

public protocol EasyDataErrorViewType: UIView {
    ///设置最后一次请求异常信息
    var error: Error? { get set }
    ///重试操作
    var retryAction: (() -> Void)? { get set }
}

open class EasyDataErrorPlugin<DataType>: EasyDataErrorPluginBase<DataType> {
    ///要加载到的页面，若为空则加载到keywindow
    open weak var targetView: UIView?

    ///配置，可修改布局及加载隐藏动画
    public var config = EasyDataPluginConfig.shared.error
    
    public lazy var errorView: EasyDataPluginConfig.ErrorView = { self.config.viewBuilder?() ?? EasyDataPluginConfig.ErrorView() }()
    
    open override func load() {
        self.errorView.error = self.error
        self.errorView.retryAction = { [weak self] in
            self?.reloadData()
        }
        if let targetView = self.targetView {
            self.config.show(errorView, at: targetView)
        }
    }
    
    open override func unload() {
        self.config.dismiss(errorView)
    }
    
}
extension EasyDataPlugin {
    ///加载失败页面
    public static func error(for view: UIView) -> EasyDataErrorPlugin<DataType> {
        let plugin = EasyDataErrorPlugin<DataType>()
        plugin.targetView = view
        return plugin
    }
}


#endif
