//
//  EasyDataErrorDecoratorType.swift
//  EasyCoding
//
//  Created by 范晓鑫 on 2020/6/25.
//

#if EASY_DATA

import UIKit

///数据请求错误装饰器，用于在数据请求异常时包装显示错误页面提供重试按钮等内容
open class EasyDataErrorPluginBase<DataType>: EasyDataPlugin<DataType>  {
    ///记录最后一次请求异常信息，用于显示
    open var error: Error?
    ///装载可视化界面
    open func load() {}
    ///卸载可视化界面
    open func unload() {}
    
    ///请求时不显示自身
    open override func didRequest(for provider: Any) {
        super.didRequest(for: provider)
        //重新请求也卸载
        self.unload()
    }
    ///请求结束后如异常则显示异常页面，但不中断回调，防止干扰业务
    open override func didResponse(for provider: Any, result: Result<DataType, Error>, completion: @escaping (Result<DataType, Error>) -> Void) {
        super.didResponse(for: provider, result: result, completion: completion)
        switch result {
        case let .failure(error):
        self.error = error
//        self.completion = completion
        self.load()
        case .success(_):
        self.error = nil
//        self.completion = nil
        //成功也卸载
        self.unload()
        }
    }
}

#endif
