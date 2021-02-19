//
//  EasyDataRefreshDecoratorType.swift
//  EasyCoding
//
//  Created by 范晓鑫 on 2020/6/26.
//
#if EASY_DATA

import UIKit

///数据刷新装饰器，用于刷新控件，比如下拉刷新
open class EasyDataRefreshPluginBase<DataType>: EasyDataPlugin<DataType> {
    ///是否只有加载成功后才加载刷新控件，默认true可配合ErrorPlugin使用
    open var initRefreshOnlySuccess: Bool = true
    ///用于判断刷新控件是否已加载
    open var isRereshInited: Bool = false
    ///初始化控件，在第一次数据加载成功后调用
    open func initRefresh() {}
    ///开始刷新操作，可在此重置数据参数
    open func beginReresh() {}
    ///结束刷新操作
    open func endRefresh() {}
    ///请求时开始刷新
    open override func willRequest(for provider: Any) -> Bool {
        if super.willRequest(for: provider) {
            if !self.initRefreshOnlySuccess && !self.isRereshInited {
                self.initRefresh()
                self.isRereshInited = true
            }
            if self.isRereshInited {
                self.beginReresh()
            }
            return true
        }else{
            return false
        }
    }
    ///请求结束后如保存刷新处理用于刷新时调用
    open override func didResponse(for provider: Any, result: Result<DataType, Error>, completion: @escaping (Result<DataType, Error>) -> Void) {
        super.didResponse(for: provider, result: result, completion: completion)
        if self.isRereshInited {
            self.endRefresh()
        }
        switch result {
        case .success(_):
//        self.completion = completion
        if !self.isRereshInited {
            self.initRefresh()
            self.isRereshInited = true
        }
        default: break
        }
    }
}

#endif
