//
//  ECDataPagedDecoratorType.swift
//  EasyCoding
//
//  Created by 范晓鑫 on 2020/6/27.
//

import UIKit

///分页数据
public protocol ECPagedDataProviderType : ECDataProviderType {
    ///首页的值，可用于重置下拉刷新或者判断是否刷新
    var firstPage: Int { get }
    ///设置页码
    var page: Int { get set }
    ///是否最后一页，若当前为最后一页则没有下拉加载新的页数
    var isLastPage: Bool { get }
}
extension ECPagedDataProviderType {
    ///第一页的值，默认为1
    public var firstPage: Int { return 1 }
    ///是否第一页，若当前为第1页则说明是刷新数据
    public var isFirstPage: Bool { return self.page == self.firstPage }
}
///数据分布装饰器，用于分页控件，比如下拉刷新上拉加载更多
public protocol ECPagedDataDecoratorType: ECDataRefreshDecoratorType where DataProviderType: ECPagedDataProviderType {
    ///用于判断刷新控件是否已加载
    var isLoadMoreInited: Bool { get set }
    ///记录最后一次请求方法，用于刷新
//    var completion: ((Result<DataType, Error>) -> Void)? { get set }
    ///初始化控件，在第一次数据加载成功后调用
    func initLoadMore()
    ///开始刷新操作，可在此重置数据参数
    func beginLoadMore()
    ///结束刷新操作
    func endLoadMore()
    ///加载下一页数据
//    func loadMore()
    ///记载每一页数据
    var datas: [DataType] { get set }
    ///转换数据？
    func convert(data: DataType) -> DataType
}
///请求异常页面的默认添加方式，可直接重写
extension ECPagedDataDecoratorType {
    ///请求时开始刷新
    public func willRequest() -> Bool {
        if self.isRereshInited {
            if let provider = self.dataProvider {
                if provider.isFirstPage {
                    self.beginReresh()
                }
            }
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
        self.completion = completion
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
        if let completion = self.completion {
            self.easyData(completion: completion)
        }
    }
}
