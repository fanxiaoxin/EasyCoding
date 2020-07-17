//
//  ApiController.swift
//  EasyCoding_Example
//
//  Created by JY_NEW on 2020/7/9.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import EasyCoding
import HandyJSON

class ApiController: ViewController<ApiView> {
//    let dataSource = ECTableViewDataSource<ListApi.DataProvider.Paged>()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "接口", style: .plain, target: self, action: #selector(self.test))
    }
    @objc func test() {
        self.page.tableView.dataProvider = ApiTest.PagedList().asDataProvider() 
        self.page.tableView.reloadDataSource()
        self.navigationItem.rightBarButtonItem = nil
    }
}
class ApiView: ECPage {
    var tableView = ECDataTableView<ApiTest.PagedList.DataProvider>()
    override func load() {
        self.easy.style(.bg(.white)).add(tableView, layout: .margin)
    }
}
