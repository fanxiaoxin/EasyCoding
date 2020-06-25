//
//  ECDataErrorDecoratorType.swift
//  EasyCoding
//
//  Created by 范晓鑫 on 2020/6/25.
//

import UIKit

///数据请求错误装饰器，用于在数据请求异常时包装显示错误页面提供重试按钮等内容
public protocol ECDataErrorDecoratorType: ECDataVisualizedDecoratorType {
    ///记录最后一次请求异常信息，用于显示
    var lastError: Error? { get set }
    ///记录最后一次请求方法，用于重试
    var lastCompletion: ((Result<DataType, Error>) -> Void)? { get set }
    ///重新加载数据
//    func reloadData()
}
///请求异常页面的默认添加方式，可直接重写
extension ECDataErrorDecoratorType {
    ///请求时不显示自身
    public func didRequest() {
        self.unload()
    }
    ///请求结束后如异常则显示异常页面，但不中断回调，防止干扰业务
    public func didResponse(for result: Result<DataType, Error>, completion: @escaping (Result<DataType, Error>) -> Void) {
        switch result {
        case let .failure(error):
        self.lastError = error
        self.lastCompletion = completion
        self.load()
        default: break
        }
    }
    ///重新加载数据
    public func reloadData() {
        if let completion = self.lastCompletion {
            self.easyData(completion: completion)
        }
    }
}
