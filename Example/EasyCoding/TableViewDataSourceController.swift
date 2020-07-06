//
//  TableViewDataSourceController.swift
//  EasyCoding_Example
//
//  Created by JY_NEW on 2020/7/6.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import EasyCoding

class TableViewDataSourceController: ECViewController<TableViewDataSourceView> {
    let dataSource = ECTableViewDataSource<ECViewDataRefreshDecorator<Provider>>()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let provider = ECViewDataRefreshDecorator<Provider>()
        provider.dataProvider = Provider()
        provider.targetView = self.page.tableView
        self.dataSource.dataProvider = provider
        self.dataSource.tableView = self.page.tableView
        
        self.dataSource.reloadData()
    }
}
class TableViewDataSourceView: ECPage {
    let tableView = UITableView()
    override func load() {
        self.easy.add(tableView.easy(.separator(.none), .row(height: 60), .sectionFooter(height: 0)), layout: .margin)
    }
}
extension TableViewDataSourceController {
    class Provider: ECDataListProviderType {
        typealias SectionType = String
        typealias ModelType = String
        typealias DataType = [String]
        
        func easyData(completion: @escaping (Result<[String], Error>) -> Void) {
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
                completion(.success(["我也A","我也B","我也C","我也D"]))
            }
        }
        
        func sections(for data: [String]) -> [String]? {
            return ["1","2", "3", "4"]
        }
        func lists(for data: [String]) -> [[String]] {
            return [data, data, data, data]
        }
        func indexTitles(for data: [String]) -> [String]? {
            return ["1", "2", "4"]
        }
        func indexPathForIndexTitle(_ title: String, at index: Int) -> IndexPath {
            if index > 2 {
                return IndexPath(row: 0, section: 3)
            }else{
                return IndexPath(row: 0, section: index)
            }
        }
    }
}
