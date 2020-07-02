//
//  ViewController.swift
//  EasyCoding
//
//  Created by fanxiaoxin_1987@126.com on 06/02/2020.
//  Copyright (c) 2020 fanxiaoxin_1987@126.com. All rights reserved.
//

import UIKit
import EasyCoding
//import SnapKit

class ViewController: ECViewController<View>, UITableViewDataSource, UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.page.tableView.dataSource = self
        self.page.tableView.delegate = self
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        switch indexPath.row {
        case 0: cell.textLabel?.text = "数据装饰器"
        case 1: cell.textLabel?.text = "Popup"
        default: break
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: self.load(DataPluginController())
        case 1: self.load(PopupController())
        default: break
        }
    }
}
class View: ECPage {
    let tableView = UITableView()
    override func load() {
        self.easy.add(tableView.easy(.cell(UITableViewCell.self, identifier: "Cell")), layout: .margin)
    }
}
///Swift5.1: Some 泛型
///Swift5.1: @propertyWrapper
///Swift5.1: @_functionBuilder
///Swift5.2: callAsFunction 把类当方法一样调用
