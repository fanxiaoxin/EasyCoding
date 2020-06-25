//
//  ECDataLoadingDecoratorType.swift
//  EasyCoding
//
//  Created by 范晓鑫 on 2020/6/25.
//

import UIKit

///数据请求中装饰器，用于在数据请求过程中包装请求动画，如：菊花
public protocol ECDataLoadingDecoratorType: ECDataVisualizedDecoratorType {
    
}
///请求动画的默认添加方式，可直接重写
extension ECDataLoadingDecoratorType {
    ///请求时加载页面
    public func didRequest() {
        self.load()
    }
    ///请求结束后卸载页面
    public func didResponse(for result: Result<DataType, Error>, completion: @escaping (Result<DataType, Error>) -> Void) {
        self.unload()
    }
}
