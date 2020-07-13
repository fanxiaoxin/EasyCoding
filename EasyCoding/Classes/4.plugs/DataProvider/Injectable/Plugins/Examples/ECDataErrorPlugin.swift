//
//  ECDataErrorDecorator.swift
//  Alamofire
//
//  Created by JY_NEW on 2020/6/30.
//

import UIKit

public protocol ECDataErrorViewType: UIView {
    ///设置最后一次请求异常信息
    var error: Error? { get set }
    ///重试操作
    var retryAction: (() -> Void)? { get set }
}

open class ECDataErrorPlugin<DataType>: ECDataErrorPluginBase<DataType> {
    ///要加载到的页面，若为空则加载到keywindow
    open weak var targetView: UIView?

    ///配置，可修改布局及加载隐藏动画
    public var config = ECDataPluginConfig.shared.error
    
    public lazy var errorView: ECDataPluginConfig.ErrorView = { self.config.viewBuilder?() ?? ECDataPluginConfig.ErrorView() }()
    
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
