//
//  ViewDataPagedDecorator.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/2.
//

import UIKit

///常用的分页数据加载
public class ECViewDataPagedDecorator<DataProviderType: ECDataPagedProviderType>: ECDataPagedDecorator<DataProviderType> {
    ///加载框
    public let loading = ECDataLoadingPlugin<DataProviderType.DataType>()
    ///加载错误页面
    public let error = ECDataErrorPlugin<DataProviderType.DataType>()
    ///数据为空页面
    public let empty = ECDataEmptyPlugin<DataProviderType.DataType>()
    ///错误提示
    public let errorToast = ECDataErrorToastPlugin<DataProviderType.DataType>()
    ///要显示控件的视图
    public override var targetView: UIScrollView? {
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