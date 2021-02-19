//
//  ViewDataRefreshDecorator.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/2.
//

#if EASY_DATA

import UIKit

///常用的可刷新数据加载
open class EasyViewDataRefreshDecorator<DataProviderType: EasyDataProviderType>: EasyViewDataDecorator<DataProviderType> {
    ///刷新控件
    let refresh = EasyDataRefreshPlugin<DataProviderType.DataType>()
    ///错误提示
//    let errorToast = EasyDataErrorToastPlugin<DataProviderType.DataType>()

    public override weak var targetView: UIView? {
        didSet {
            self.refresh.targetView = self.targetView as? UIScrollView
        }
    }
    
    public override init() {
        super.init()
        
        empty.unloadWhenRequest = false
        
//        errorToast.activate({ [weak refresh] in
//            return refresh?.isRereshInited ?? false
//        })
//        error.activate ({ [weak refresh] in
//            return !(refresh?.isRereshInited ?? true)
//        })
        loading.activate { [weak refresh] () -> Bool in
            return !(refresh?.isRereshInited ?? true)
        }
        
        self.plugins = [loading, error, empty, errorToast, refresh]
    }
}

#endif
