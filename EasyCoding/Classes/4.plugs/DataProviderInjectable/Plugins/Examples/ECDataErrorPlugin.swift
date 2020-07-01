//
//  ECDataErrorDecorator.swift
//  Alamofire
//
//  Created by JY_NEW on 2020/6/30.
//

import UIKit

open class ECDataErrorPlugin<DataType>: ECDataErrorPluginBase<DataType> {
    ///要加载到的页面，若为空则加载到keywindow
    open weak var targetView: UIView?
    ///加载页
    open lazy var errorView: ECDataErrorViewType = {
        return ECDataErrorDecorator<DataType>.ErrorView()
    }()
    open override func load() {
        self.errorView.error = self.error
        self.errorView.retryAction = { [weak self] in
            self?.reloadData()
        }
        self.targetView?.easy.add(self.errorView, layout: .center)
    }
    
    open override func unload() {
        self.errorView.removeFromSuperview()
    }
}
