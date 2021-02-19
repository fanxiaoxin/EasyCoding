//
//  EasyDataLoadingDecoratorType.swift
//  EasyCoding
//
//  Created by 范晓鑫 on 2020/6/25.
//
#if EASY_DATA

import UIKit

///数据请求中装饰器，用于在数据请求过程中包装请求动画，如：菊花
open class EasyDataLoadingPluginBase<DataType>: EasyDataPlugin<DataType>  {
    ///装载可视化界面
    open func load() { }
    ///卸载可视化界面
    open func unload() { }
    ///请求时加载页面
    open override func didRequest(for provider: Any) {
        super.didRequest(for: provider)
        self.load()
    }
    ///请求结束后卸载页面
    open override func didResponse(for provider: Any, result: Result<DataType, Error>, completion: @escaping (Result<DataType, Error>) -> Void) {
        super.didResponse(for: provider, result: result, completion: completion)
        self.unload()
    }
}

#endif
