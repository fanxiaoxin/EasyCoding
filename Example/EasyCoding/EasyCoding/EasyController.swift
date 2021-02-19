//
//  EasyController.swift
//  EasyCoding_Example
//
//  Created by 范晓鑫 on 2021/2/10.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit

class EasyController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "EasyCoding"
        
        self.tableView.easy.style(.cell(UITableViewCell.self))
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: .easyCellIdentifier)!
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "视图构建及样式设置"
        case 1:
            cell.textLabel?.text = "AttributedString"
        default: break
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: self.navigationController?.pushViewController(ViewBuildController(), animated: true)
        case 1: self.navigationController?.pushViewController(AttributeStringController(), animated: true)
        default: break
        }
    }
}
