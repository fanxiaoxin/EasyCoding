//
//  ECDataErrorDecoratorType.swift
//  EasyCoding
//
//  Created by 范晓鑫 on 2020/6/25.
//

import UIKit

///抽象的数据请求错误页面
public protocol ECDataErrorViewType: UIView {
    ///设置错误内容
    var error: Error? { get set }
    ///重试操作，由控件去设置，继承方只管在重试按钮调用就行
    var retryAction: (() -> Void)? { get set }
}
///数据请求错误装饰器，用于在数据请求异常时包装显示错误页面提供重试按钮等内容
protocol ECDataErrorDecoratorType: ECDataVisualizedDecoratorType {
    ///请求异常视图
    var errorView: ECDataErrorViewType { get }
    ///记录最后一次请求异常信息，用于显示
    var lastError: Error? { get set }
    ///记录最后一次请求方法，用于重试
    var lastCompletion: ((DataType?, Error?) -> Void)? { get set }
}
///请求异常页面的默认添加方式，可直接重写
extension ECDataErrorDecoratorType {
    ///请求结束后如异常则显示异常页面，但不中断回调，防止干扰业务
    public func willResponse(for data: DataType?, error: Error?, completion: @escaping (DataType?, Error?) -> Void) -> Bool {
        if let err = error {
            self.lastError = err
            self.lastCompletion = completion
            self.load()
        }
        return true
    }
    ///默认加载错误页面布满父视图
    public func load() {
        let view = self.errorView
        view.error = self.lastError
        view.retryAction = { [weak self] in
            if let s = self, let completion = self?.lastCompletion {
                s.easyData(completion: completion)
            }
        }
        self.targetView?.easy.add(view, layout: .margin)
    }
    ///默认将异常页面删除
    public func unload() {
        self.errorView.removeFromSuperview()
    }
}
