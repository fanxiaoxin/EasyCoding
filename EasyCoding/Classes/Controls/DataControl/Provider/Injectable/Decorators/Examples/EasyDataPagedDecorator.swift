//
//  EasyDataPagedDecorator.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/2.
//

#if EASY_DATA

import UIKit
#if canImport(MJRefresh)
import MJRefresh
#endif

open class EasyDataPagedDecorator<DataProviderType: EasyDataPagedProviderType>: EasyDataPagedDecoratorBase<DataProviderType> {
    //要显示下拉刷新的视图
    open weak var targetView: UIScrollView?
    
    #if canImport(MJRefresh)
    ///mj_header
    open lazy var header: MJRefreshHeader = {
        EasyDataPluginConfig.shared.headerBuilder()
    }()
    
    ///mj_footer
    open lazy var footer: MJRefreshFooter = {
        EasyDataPluginConfig.shared.footerBuilder()
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
        if let data = self.data, !self.isLoadMoreFinished {
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
        if self.data == nil || self.isLoadMoreFinished {
            self.footer.endRefreshingWithNoMoreData()
        }
    }
    ///结束加载更多操作
    open override func endLoadMore() {
        if self.data == nil || self.isLoadMoreFinished {
            self.footer.endRefreshingWithNoMoreData()
        }else{
            self.footer.endRefreshing()
        }
    }
    #endif
}


extension EasyDataPlugin {
    ///使用分页插件装饰器
    public static func paged<DataProviderType: EasyDataPagedProviderType>(for target: UIScrollView, provider: DataProviderType? = nil) -> EasyDataPagedDecorator<DataProviderType> where DataProviderType.DataType == DataType {
        let plugin = EasyDataPagedDecorator<DataProviderType>()
        plugin.targetView = target
        plugin.dataProvider = provider
        return plugin
    }
}

extension EasyDataPagedProviderType {
    public typealias Paged = EasyDataPagedDecorator<Self>
    ///使用分页插件装饰器
    public func paged(for target: UIScrollView,_ plugins: EasyDataPlugin<DataType>...) -> EasyDataPagedDecorator<Self> {
        let plugin = EasyDataPagedDecorator<Self>()
        plugin.targetView = target
        plugin.dataProvider = self
        plugin.plugins = plugins
        return plugin
    }
}

#endif
