//
//  EasyViewDataDecorator.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/2.
//

#if EASY_DATA

import UIKit

///常用的单页数据第一次加载
open class EasyViewDataDecorator<DataProviderType: EasyDataProviderType>: EasyDataPluginDecorator<DataProviderType> {
    ///错误时是否弹toast，否则显示错误页面
    var isToastForError = false
    ///是否所有的错误都加载错误页，否则只要加载过一次成功，后面的错误则只弹toast
    open var loadErrorViewForAllError = false {
        didSet {
            if self.loadErrorViewForAllError == true {
                self.isToastForError = false
            }
        }
    }
    ///日志
//    public let log = EasyDataLogPlugin<DataProviderType.DataType>()
    ///加载框
    public let loading = EasyDataLoadingPlugin<DataProviderType.DataType>()
    ///显示toast错误，在第二次加载则不显示错误页面而是直接弹出错误内容
    public let errorToast = EasyDataErrorToastPlugin<DataProviderType.DataType>()
    ///加载错误页面
    public let error = EasyDataErrorPlugin<DataProviderType.DataType>()
    ///数据为空页面
    public let empty = EasyDataEmptyPlugin<DataProviderType.DataType>()
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
        errorToast.activate({ [weak self] in
            return self?.isToastForError ?? false
        })
        error.activate ({ [weak self] in
            return !(self?.isToastForError ?? false)
        })
        self.plugins = [loading, error, empty, errorToast]
    }
    
    open override func didResponse(for provider: Any, result: Result<DataType, Error>, completion: @escaping (Result<DataType, Error>) -> Void) {
        super.didResponse(for: provider, result: result, completion: completion)
        if !self.loadErrorViewForAllError && result.success {
            self.isToastForError = true
        }
    }
}

#endif
