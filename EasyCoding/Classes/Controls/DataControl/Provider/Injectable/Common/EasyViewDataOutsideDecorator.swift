//
//  EasyViewDataOutsideDecorator.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/25.
//

#if EASY_DATA

import UIKit

///常用的在指定页面显示加载，但失败时只弹toast，也没有空数据页面
open class EasyViewDataOutsideDecorator<DataProviderType: EasyDataProviderType>: EasyDataPluginDecorator<DataProviderType> {
    ///日志
//    public let log = EasyDataLogPlugin<DataProviderType.DataType>()
    ///加载框
    public let loading = EasyDataLoadingPlugin<DataProviderType.DataType>()
    ///加载错误页面
    public let errorToast = EasyDataErrorToastPlugin<DataProviderType.DataType>()
    ///要显示控件的视图
    public weak var targetView: UIView? {
        didSet {
            self.loading.targetView = self.targetView
        }
    }
    public override init() {
        super.init()
        self.plugins = [loading, errorToast]
    }
}

#endif
