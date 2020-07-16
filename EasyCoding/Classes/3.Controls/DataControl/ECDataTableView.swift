//
//  ECDataTableView.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/13.
//

import UIKit

open class ECDataTableView<DataProviderType: ECDataListProviderType>: UITableView, ECDataScrollViewType {
    ///数据源
    public let easyDataSource = ECTableViewDataSource<ECDataPluginDecorator<DataProviderType>>()
    ///数据插件
    public var dataPlugin: ECDataPluginDecorator<DataProviderType>? {
        didSet {
            self.easyDataSource.dataProvider = self.dataPlugin
        }
    }
    
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.load()
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.load()
    }
    open func load() {
        self.easyDataSource.tableView = self
    }
    ///重新加载数据
    open func reloadDataSource() {
        self.easyDataSource.reloadData()
    }
}
