//
//  ECDataRefreshDecorator.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/30.
//

import UIKit
import MJRefresh

///数据刷新装饰器，用于刷新控件，比如下拉刷新
open class ECDataRefreshDecorator<DataType>: ECDataRefreshDecoratorType {
    deinit {
        print(NSStringFromClass(Self.self) + "die")
    }
   
   public var dataProvider: ((@escaping (Result<DataType, Error>) -> Void, @escaping (Result<DataType, Error>) -> Void) -> Void)?
    
    public var isRereshInited: Bool = false
    
    ///设置最后一次原始请求操作，可用于重试
    public var originalCompletion: ((Result<DataType, Error>) -> Void)?
    
    //要显示下拉刷新的视图
    open var targetView: UIScrollView?
    
    ///mj_header
    open lazy var header: MJRefreshHeader = {
        return MJRefreshNormalHeader()
    }()
    
    
    open func initRefresh() {
        self.targetView?.mj_header = self.header
        self.header.refreshingBlock = { [weak self] in
            self?.reloadData()
        }
    }
    
    open func endRefresh() {
        self.header.endRefreshing()
    }
    
    public required init() {
           
    }
}
