//
//  EasyDataRefreshDecorator.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/30.
//
#if EASY_DATA

import UIKit
#if canImport(MJRefresh)
import MJRefresh
#endif

///数据刷新装饰器，用于刷新控件，比如下拉刷新
open class EasyDataRefreshPlugin<DataType>: EasyDataRefreshPluginBase<DataType> {
    //要显示下拉刷新的视图
    open weak var targetView: UIScrollView?
    
    #if canImport(MJRefresh)
    ///mj_header
    open lazy var header: MJRefreshHeader = {
        EasyDataPluginConfig.shared.headerBuilder()
    }()
    
    
    open override func initRefresh() {
        self.targetView?.mj_header = self.header
        self.header.refreshingBlock = { [weak self] in
            self?.reloadData()
        }
    }
    
    open override func endRefresh() {
        self.header.endRefreshing()
    }
    #endif
}

extension EasyDataPlugin {
    ///可下拉刷新
    public static func refresh(for view: UIScrollView) -> EasyDataRefreshPlugin<DataType> {
        let plugin = EasyDataRefreshPlugin<DataType>()
        plugin.targetView = view
        return plugin
    }
}

#endif
