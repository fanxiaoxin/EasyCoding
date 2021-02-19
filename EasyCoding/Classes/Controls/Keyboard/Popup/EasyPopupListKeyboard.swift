//
//  EasyPopupListKeyboard.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/8.
//
#if EASY_DATA

import UIKit

open class EasyPopupListKeyboard<DataProviderType: EasyDataListProviderType>: EasyPopupKeyboard<DataProviderType.ModelType> {
    
    public let tableView = UITableView()
    public let dataSource = EasyTableViewDataSource<DataProviderType>()
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

#endif
