//
//  ECDataRefreshDecorator.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/30.
//

import UIKit
import MJRefresh

///数据刷新装饰器，用于刷新控件，比如下拉刷新
open class ECDataRefreshPlugin<DataType>: ECDataRefreshPluginBase<DataType> {
    //要显示下拉刷新的视图
    open weak var targetView: UIScrollView?
    
    ///mj_header
    open lazy var header: MJRefreshHeader = {
        ECDataPluginConfig.shared.headerBuilder()
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
}

extension ECDataPlugin {
    ///可下拉刷新
    public static func refresh(for view: UIScrollView) -> ECDataRefreshPlugin<DataType> {
        let plugin = ECDataRefreshPlugin<DataType>()
        plugin.targetView = view
        return plugin
    }
}
