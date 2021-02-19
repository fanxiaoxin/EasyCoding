//
//  ViewDataPagedDecorator.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/2.
//

#if EASY_DATA

import UIKit

///常用的分页数据加载
open class EasyViewDataPagedDecorator<DataProviderType: EasyDataPagedProviderType>: EasyDataPagedDecorator<DataProviderType> {
    ///日志
//    public let log = EasyDataLogPlugin<DataProviderType.DataType>()
    ///加载框
    public let loading = EasyDataLoadingPlugin<DataProviderType.DataType>()
    ///加载错误页面
    public let error = EasyDataErrorPlugin<DataProviderType.DataType>()
    ///数据为空页面
    public let empty = EasyDataEmptyPlugin<DataProviderType.DataType>()
    ///错误提示
    public let errorToast = EasyDataErrorToastPlugin<DataProviderType.DataType>()
    ///要显示控件的视图
    public override weak var targetView: UIScrollView? {
        didSet {
            self.loading.targetView = self.targetView
            self.error.targetView = self.targetView
            self.empty.targetView = self.targetView
        }
    }
    public override init() {
        super.init()
        
        empty.unloadWhenRequest = false
        
        errorToast.activate({ [weak self] in
            return self?.isRereshInited ?? false
        })
        error.activate ({ [weak self] in
            return !(self?.isRereshInited ?? true)
        })
        loading.activate { [weak self] () -> Bool in
            return !(self?.isRereshInited ?? true)
        }
        empty.isEmpty = { [weak self] _ in
            return (self?.data).isEmpty
        }
        
        self.plugins = [loading, error, empty, errorToast]
    }
}

#endif
