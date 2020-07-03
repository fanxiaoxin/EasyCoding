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
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        switch indexPath.row {
        case 0: cell.textLabel?.text = "数据装饰器"
        case 1: cell.textLabel?.text = "Popup"
        case 2: cell.textLabel?.text = "Alert"
        case 3: cell.textLabel?.text = "呈现动画"
        default: break
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: self.load(DataPluginController())
        case 1: self.load(PopupController())
        case 2:
            ECSetting.Alert.container.addStyle(.border(.systemBlue))
//            ECSetting.Alert.presentAnimation = ECPresentAnimation.Popup(anchor: .easy(1))
            ECSetting.Alert.presentAnimation = ECPresentAnimation.SlideOut(direction: .right)
            ECMessageBox.confirm(message: "点下我") {
                print("你点了确定")
            }
        case 3:
            self.page.animationView.easy.slideOut(direction: .top)
        default: break
        }
    }
    @objc func onDismissAnimation() {
        self.page.animationView.easy.dismiss()
    }
}
class View: ECPage {
    let tableView = UITableView()
    let animationView = UIView()
    override func load() {
        self.easy.add(tableView.easy(.cell(UITableViewCell.self, identifier: "Cell")), layout: .margin)
        
        self.easy.add(animationView.easy(.bg(.systemGreen), .hidden()), layout: .center, .size(200))
            .add(button("DismissAnimation", .text("关闭"), .bg(.blue), .color(.white), .corner(4)), layout: .size(80, 44), .center)
    }
}
///Swift5.1: Some 泛型
///Swift5.1: @propertyWrapper
///Swift5.1: @_functionBuilder
///Swift5.2: callAsFunction 把类当方法一样调用
