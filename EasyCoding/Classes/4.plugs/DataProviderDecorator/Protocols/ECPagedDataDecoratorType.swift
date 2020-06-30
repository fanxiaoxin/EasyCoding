//
//  ECDataPagedDecoratorType.swift
//  EasyCoding
//
//  Created by 范晓鑫 on 2020/6/27.
//

import UIKit

///分页数据
public protocol ECPagedDataProviderType : ECDataProviderType{
    ///首页的值，可用于重置下拉刷新或者判断是否刷新
    var firstPage: Int { get }
    ///设置页码`
    var page: Int { get set }
    ///是否最后一页，若当前为最后一页则没有下拉加载新的页数
    var isLastPage: Bool { get }
    ///将分页数据进行整合
    func merge(data data1: DataType, to data2:DataType) -> DataType
}
extension ECPagedDataProviderType {
    ///第一页的值，默认为1
    public var firstPage: Int { return 1 }
    ///是否第一页，若当前为第1页则说明是刷新数据
    public var isFirstPage: Bool { return self.page == self.firstPage }
    ///是否最后一页，若当前为最后一页则没有下拉加载新的页数
    public var isLastPage: Bool { return false }
    ///重置为第一页
    public mutating func resetPage() {
        self.page = self.firstPage
    }
}
///数据分布装饰器，用于分页控件，比如下拉刷新上拉加载更多
public protocol ECPagedDataDecoratorType: ECDataProviderDecoratorType where DataProviderType: ECPagedDataProviderType {
    ///数据请求标识，用于标识是否同一次请求
    var requestFlag: Int { get set }
    ///用于判断刷新控件是否已加载
    var isRereshInited: Bool { get set }
    ///记录最后一次请求方法，用于刷新或加载更多
    var completion: ((Result<DataType, Error>) -> Void)? { get set }
    ///初始化刷新控件，在第一次数据加载成功后调用
    func initRefresh()
    ///开始刷新操作，可在此重置数据参数
    func beginReresh()
    ///结束刷新操作
    func endRefresh()
    ///重新加载数据
    //    func reloadData()
    ///用于判断刷新控件是否已加载
    var isLoadMoreInited: Bool { get set }
    ///初始化加载更多控件，在第一次数据加载成功后调用
    func initLoadMore()
    ///开始加载更多操作，可在此重置数据参数
    func beginLoadMore()
    ///结束加载更多操作
    func endLoadMore()
    ///加载下一页数据
//    func loadMore()
    ///当前数据
    var data: DataType? { get set }
}
///请求异常页面的默认添加方式，可直接重写
extension ECPagedDataDecoratorType {
    public typealias DataType = DataProviderType.DataType
    ///请求时开始刷新
    public func didRequest() {
        if let provider = self.dataProvider {
            if self.isRereshInited {
                if provider.isFirstPage {
                    self.beginReresh()
                }else{
                    self.beginLoadMore()
                }
            }
        }
    }
    ///请求结束后如保存刷新处理用于刷新时调用
    public func didResponse(for result: Result<DataType, Error>, completion: @escaping (Result<DataType, Error>) -> Void) {
        if self.isRereshInited && self.dataProvider!.isFirstPage {
            self.endRefresh()
        }
        if self.isLoadMoreInited && !self.dataProvider!.isFirstPage {
            self.endLoadMore()
        }
        switch result {
        case .success(_):
            //只有第一次才记录
            if self.completion == nil {
                self.completion = completion
            }
        if !self.isRereshInited {
            self.initRefresh()
            self.isRereshInited = true
        }
        if !self.isLoadMoreInited {
            self.initLoadMore()
            self.isLoadMoreInited = true
        }
        default: break
        }
    }
    ///开始刷新操作默认不处理
    public func beginReresh() {}
    ///重新加载数据
    public func reloadData() {
        let page = self.dataProvider!.page
        self.dataProvider!.resetPage()
        if let completion = self.completion {
            self.requestFlag += 1
            let flag = self.requestFlag
            self.easyData { [weak self] (result) in
                if flag == self?.requestFlag {
                    switch result {
                    case let .success(data):
                        self?.data = data
                        completion(.success(data))
                    case let .failure(error):
                        self?.dataProvider?.page = page
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    ///开始加载更多操作默认不处理
    public func beginLoadMore() {}
    ///加载更多
    public func loadMore() {
        self.dataProvider?.page += 1
        if let completion = self.completion {
            self.requestFlag += 1
            let flag = self.requestFlag
            self.easyData { [weak self] (result) in
                if flag == self?.requestFlag {
                    switch result {
                    case let .success(data):
                        if let s = self {
                            s.data = s.dataProvider!.merge(data: data, to: s.data!)
                            completion(.success(s.data!))
                        }
                    case let .failure(error):
                        completion(.failure(error))
                        self?.dataProvider?.page -= 1
                    }
                }
            }
        }
    }
}
