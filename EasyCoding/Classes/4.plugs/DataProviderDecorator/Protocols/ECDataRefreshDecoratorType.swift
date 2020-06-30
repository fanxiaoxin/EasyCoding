//
//  ECDataRefreshDecoratorType.swift
//  EasyCoding
//
//  Created by 范晓鑫 on 2020/6/26.
//

import UIKit

///数据刷新装饰器，用于刷新控件，比如下拉刷新
public protocol ECDataRefreshDecoratorType: ECDataProviderGenericDecoratorType {
    ///用于判断刷新控件是否已加载
    var isRereshInited: Bool { get set }
    ///初始化控件，在第一次数据加载成功后调用
    func initRefresh()
    ///开始刷新操作，可在此重置数据参数
    func beginReresh()
    ///结束刷新操作
    func endRefresh()
    ///重新加载数据
//    func reloadData()
}
///请求异常页面的默认添加方式，可直接重写
extension ECDataRefreshDecoratorType {
    ///请求时开始刷新
    public func willRequest() -> Bool {
        if self.isRereshInited {
            self.beginReresh()
        }
        return true
    }
    ///请求结束后如保存刷新处理用于刷新时调用
    public func didResponse(for result: Result<DataType, Error>, completion: @escaping (Result<DataType, Error>) -> Void) {
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
    ///开始刷新操作默认不处理
    public func beginReresh() {}
    ///重新加载数据
    public func reloadData() {
        if let completion = self.originalCompletion {
            self.easyData(completion: completion)
        }
    }
}
