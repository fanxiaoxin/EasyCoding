//
//  ECPopupListKeyboard.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/8.
//

import UIKit

open class ECPopupListKeyboard<DataProviderType: ECDataListProviderType>: ECPopupKeyboard<DataProviderType.ModelType> {
    
    public let tableView = UITableView()
    public let dataSource = ECTableViewDataSource<DataProviderType>()
    ///数据源
    open var dataProvider: DataProviderType? {
        get {
            return self.dataSource.dataProvider
        }
        set {
            self.dataSource.dataProvider = newValue
            self.dataSource.reloadData()
        }
    }
    
    open override func load() {
        self.contentView.easy.add(self.tableView, layout: .margin)
        
        self.dataSource.tableView = self.tableView
        self.dataSource.actionForSelect = { [weak self] _, model, _ in
            self?.input(model)
            self?.dismiss()
        }
    }
}
