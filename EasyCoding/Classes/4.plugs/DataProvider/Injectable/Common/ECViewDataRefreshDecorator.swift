//
//  ViewDataRefreshDecorator.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/2.
//

import UIKit

///常用的可刷新数据加载
public class ECViewDataRefreshDecorator<DataProviderType: ECDataProviderType>: ECViewDataDecorator<DataProviderType> {
    ///刷新控件
    let refresh = ECDataRefreshPlugin<DataProviderType.DataType>()
    ///错误提示
    let errorToast = ECDataErrorToastPlugin<DataProviderType.DataType>()

    public override var targetView: UIView? {
        didSet {
            self.refresh.targetView = self.targetView as? UIScrollView
        }
    }
    
    public override init() {
        super.init()
        
        empty.unloadWhenRequest = false
        
        errorToast.activate({ [weak refresh] in
            return refresh?.isRereshInited ?? false
        })
        error.activate ({ [weak refresh] in
            return !(refresh?.isRereshInited ?? true)
        })
        loading.activate { [weak refresh] () -> Bool in
            return !(refresh?.isRereshInited ?? true)
        }
        
        self.plugins = [loading, error, empty, errorToast, refresh]
    }
}