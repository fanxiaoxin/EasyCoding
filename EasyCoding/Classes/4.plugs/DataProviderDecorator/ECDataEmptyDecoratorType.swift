//
//  ECDataEmptyDecoratorType.swift
//  EasyCoding
//
//  Created by 范晓鑫 on 2020/6/25.
//

import UIKit

///抽象的数据空数据页面
public protocol ECDataEmptyViewType: UIView {
    
}

///数据请求成功但数据为空装饰器，用于在数据请求后包装空数据页面
public protocol ECDataEmptyDecoratorType: ECDataVisualizedDecoratorType {
    var emptyView: ECDataEmptyViewType { get }
}
///空数据页面的默认添加方式，可直接重写
extension ECDataEmptyDecoratorType {
    ///请求结束后如成功但数据为空则显示空数据页面，但不中断回调，防止干扰业务
    public func willResponse(for data: DataType?, error: Error?, completion: @escaping (DataType?, Error?) -> Void) -> Bool {
        if error == nil {
            if data == nil {
                self.load()
            }else if let content = data as? ECEmptiable, content.isEmpty {
                self.load()
            }
        }
        return true
    }
    ///默认加载空数据页面布满父视图
    public func load() {
        self.targetView?.easy.add(self.emptyView, layout: .center)
    }
    ///默认将空数据页面删除
    public func unload() {
        self.emptyView.removeFromSuperview()
    }
}
