//
//  DataPagedDecorator.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/2.
//

#if EASY_DATA

import UIKit

///分页数据装饰器
open class EasyDataPagedDecoratorBase<DataProviderType: EasyDataPagedProviderType>: EasyDataPluginDecorator<DataProviderType> {
    // MARK: 数据加载操作
    //用于标记是否当前正在加载，若被刷掉则可以用来中断前一个加载
    fileprivate var _requestFlag = 0
    ///当前加载的数据
    public var data: DataType? {
        didSet {
            if let data = self.data {
                self.isLoadMoreFinished = self.isLastPage(for: data)
            }else{
                self.isLoadMoreFinished = true
            }
        }
    }
    ///重新加载数据时重置为首页
    public override func reloadData() {
        if var provider = self.dataProvider {
            //更新请求标识，用于判断是否同一次请求，若请求过程中有别的请求则忽略当次
            self._requestFlag += 1
            let requestFlag = self._requestFlag
            ///保留页码，用于失败时还原
            let page = provider.page
            provider.page = 1
            self.easyDataInject { [weak self] (result) in
                if requestFlag == self?._requestFlag {
                    switch result {
                    case let .success(data):
                        self?.data = data
                        self?.lastCompletion?(.success(data))
                    case .failure(_):
                        self?.dataProvider?.page = page
                        self?.lastCompletion?(result)
                    }
                }
            }
        }
    }
    ///加载下一页
    public func loadMore() {
        if var provider = self.dataProvider {
            //更新请求标识，用于判断是否同一次请求，若请求过程中有别的请求则忽略当次
            self._requestFlag += 1
            let requestFlag = self._requestFlag
            ///保留页码，用于失败时还原
            let page = provider.page
            provider.page += 1
            self.easyDataInject { [weak self] (result) in
                if requestFlag == self?._requestFlag {
                    switch result {
                    case let .success(data):
                        if let s = self {
                            ///将数据进行整合
                            if let data1 = s.data {
                                s.data = s.dataProvider?.merge(data1: data1, data2: data)
                                s.isLoadMoreFinished = s.isLastPage(for: data)
                            }else{
                                s.data = data
                            }
                            s.lastCompletion?(.success(s.data!))
                        }
                    case .failure(_):
                        self?.dataProvider?.page = page
                        self?.lastCompletion?(result)
                    }
                }
            }
        }
    }
    // MARK: 分页控件操作
    ///是否只有加载成功后才加载刷新控件，默认true可配合ErrorPlugin使用
    open var initRefreshOnlySuccess: Bool = true
    ///用于判断刷新控件是否已加载
    open var isRereshInited: Bool = false
    ///初始化刷新控件，在第一次数据加载成功后调用
    open func initRefresh() {}
    ///开始刷新操作
    open func beginReresh() {}
    ///结束刷新操作
    open func endRefresh() {}
    ///用于判断分页控件是否已加载
    open var isLoadMoreInited: Bool = false
    ///是否已没有下一页
    open var isLoadMoreFinished: Bool = false
    ///初始化加载更多控件，在第一次数据加载成功后调用
    open func initLoadMore() {}
    ///开始加载更多操作
    open func beginLoadMore() {}
    ///结束加载更多操作
    open func endLoadMore() {}
    
    open override func willRequest(for provider: Any) -> Bool {
        if super.willRequest(for: provider) {
            if !self.initRefreshOnlySuccess && !self.isRereshInited {
                self.initRefresh()
                self.isRereshInited = true
            }
            ///区分是刷新还是加载更多
            if let isFirstPage = self.dataProvider?.isFirstPage {
                if isFirstPage {
                    if self.isRereshInited {
                        self.beginReresh()
                    }
                }else{
                    if self.isLoadMoreInited {
                        self.beginLoadMore()
                    }
                }
            }
            return true
        }
        return false
    }
    ///请求结束前保存刷新处理用于刷新时调用
    /*
    open override func willResponse(for result: Result<DataProviderType.DataType, Error>, completion: @escaping (Result<DataProviderType.DataType, Error>) -> Void) -> Result<DataProviderType.DataType, Error>? {
        if let result = super.willResponse(for: result, completion: completion) {
            //因为有可能在刷新的同时又加载更多或者反过来，所以需要同时调用结束，不区分上下拉
            if self.isRereshInited {
                self.endRefresh()
            }
            if self.isLoadMoreInited {
                self.endLoadMore()
            }
            switch result {
            case let .success(data):
                if !self.isRereshInited {
                    self.initRefresh()
                    self.isRereshInited = true
                }
                if !self.isLoadMoreInited {
                    self.initLoadMore()
                    self.isLoadMoreInited = true
                }
                ///首次加载时设置数据
                if self.data == nil {
                    self.data = data
                }
            default: break
            }
            return result
        }
        return nil
    }*/
    open override func didResponse(for provider: Any, result: Result<DataProviderType.DataType, Error>, completion: @escaping (Result<DataProviderType.DataType, Error>) -> Void) {
        //因为有可能在刷新的同时又加载更多或者反过来，所以需要同时调用结束，不区分上下拉
        if self.isRereshInited {
            self.endRefresh()
        }
        if self.isLoadMoreInited {
            self.endLoadMore()
        }
        switch result {
        case let .success(data):
            ///首次加载时设置数据
            if self.data == nil {
                self.data = data
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
        super.didResponse(for: provider, result: result, completion: completion)
    }
}

#endif
