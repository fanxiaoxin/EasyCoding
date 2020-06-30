//
//  ECDataEmptyDecoratorType.swift
//  EasyCoding
//
//  Created by 范晓鑫 on 2020/6/25.
//

import UIKit

///数据请求成功但数据为空装饰器，用于在数据请求后包装空数据页面
public protocol ECDataEmptyDecoratorType: ECDataProviderGenericDecoratorType {
    ///装载可视化界面
    func load()
    ///卸载可视化界面
    func unload()
}
///空数据页面的默认添加方式，可直接重写
extension ECDataEmptyDecoratorType {
    ///请求时不显示自身
    public func didRequest() {
        self.unload()
    }
    ///请求结束后如成功但数据为空则显示空数据页面，但不中断回调，防止干扰业务
    public func didResponse(for result: Result<DataType, Error>, completion: @escaping (Result<DataType, Error>) -> Void) {
        switch result {
        case let .success(data):
            if let content = data as? ECEmptiable, content.isEmpty {
                self.load()
            }else{
                self.unload()
            }
        case .failure(_):
            self.unload()
        }
    }
}
