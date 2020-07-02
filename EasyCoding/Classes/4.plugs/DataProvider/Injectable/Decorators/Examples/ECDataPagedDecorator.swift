//
//  ECDataPagedDecorator.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/2.
//

import UIKit
import MJRefresh

open class ECDataPagedDecorator<DataProviderType: ECDataPagedProviderType>: ECDataPagedDecoratorBase<DataProviderType> {
    //要显示下拉刷新的视图
    open var targetView: UIScrollView?
    
    ///mj_header
    open lazy var header: MJRefreshHeader = {
        return MJRefreshNormalHeader()
    }()
    
    ///mj_footer
    open lazy var footer: MJRefreshFooter = {
        return MJRefreshBackStateFooter()
    }()
    
    open override func initRefresh() {
        self.targetView?.mj_header = self.header
        self.header.refreshingBlock = { [weak self] in
            self?.reloadData()
        }
    }
    
    open override func endRefresh() {
        self.header.endRefreshing()
        //若刷新的时候不是只有一页则设置可上拉加载更多
        if !(self.dataProvider?.isLastPage ?? true) {
            self.footer.resetNoMoreData()
        }
    }
    
    ///初始化加载更多控件，在第一次数据加载成功后调用
    open override func initLoadMore() {
        self.targetView?.mj_footer = self.footer
        self.footer.refreshingBlock = { [weak self] in
            self?.loadMore()
        }
        //若初始化的时候只有一页则设置已全部加载
        if self.dataProvider?.isLastPage ?? true {
            self.footer.endRefreshingWithNoMoreData()
        }
    }
    ///结束加载更多操作
    open override func endLoadMore() {
        if self.dataProvider?.isLastPage ?? true {
            self.footer.endRefreshingWithNoMoreData()
        }else{
            self.footer.endRefreshing()
        }
    }
    
}
