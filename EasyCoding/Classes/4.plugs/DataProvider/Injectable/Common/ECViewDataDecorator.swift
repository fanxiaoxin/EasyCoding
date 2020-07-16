//
//  ECViewDataDecorator.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/2.
//

import UIKit

///常用的单页数据加载
open class ECViewDataDecorator<DataProviderType: ECDataProviderType>: ECDataPluginDecorator<DataProviderType> {
    ///日志
//    public let log = ECDataLogPlugin<DataProviderType.DataType>()
    ///加载框
    public let loading = ECDataLoadingPlugin<DataProviderType.DataType>()
    ///加载错误页面
    public let error = ECDataErrorPlugin<DataProviderType.DataType>()
    ///数据为空页面
    public let empty = ECDataEmptyPlugin<DataProviderType.DataType>()
    ///要显示控件的视图
    public weak var targetView: UIView? {
        didSet {
            self.loading.targetView = self.targetView
            self.error.targetView = self.targetView
            self.empty.targetView = self.targetView
        }
    }
    public override init() {
        super.init()
        empty.unloadWhenRequest = true
        self.plugins = [loading, error, empty]
    }
}
