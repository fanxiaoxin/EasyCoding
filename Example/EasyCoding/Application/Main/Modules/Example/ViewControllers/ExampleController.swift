//
//  ViewController.swift
//  EasyCoding
//
//  Created by fanxiaoxin_1987@126.com on 06/02/2020.
//  Copyright (c) 2020 fanxiaoxin_1987@126.com. All rights reserved.
//

import UIKit
import EasyCoding
import PromiseKit

class ExampleController: ViewController<ExampleView>, UITableViewDataSource, UITableViewDelegate {
    let popupRect = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.page.tableView.dataSource = self
        self.page.tableView.delegate = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "键盘", style: .plain, target: self, action: #selector(self.test))
        
        self.page.easy.add(popupRect.easy(.bg(.gray)), layout: .top(20), .left(20), .size(80, 30))
        UIViewController.easy.when(.dealloc) {
            print("all view die")
        }
    }
    @objc func test() {
        let keyboard = ECPopupListKeyboard<[String]>(from: popupRect)
        keyboard.dataProvider = ["A","B","C","D"]
        //        keyboard.minSize = .easy(80, 100)
        keyboard.inputReceive = { value in
            print(value)
        }
        keyboard.show()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        switch indexPath.row {
        case 0: cell.textLabel?.text = "数据装饰器"
        case 1: cell.textLabel?.text = "Popup"
        case 2: cell.textLabel?.text = "Alert"
        case 3: cell.textLabel?.text = "呈现动画"
        case 4: cell.textLabel?.text = "TableView数据源"
        case 5: cell.textLabel?.text = "CollectionView数据源"
        case 6: cell.textLabel?.text = "PickerView数据源"
        case 7: cell.textLabel?.text = "PickerView多数据源"
        case 8: cell.textLabel?.text = "键盘"
        case 9: cell.textLabel?.text = "TextField输入限制"
        case 10: cell.textLabel?.text = "Api"
        case 11: cell.textLabel?.text = "测试"
        default: break
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            //            let controller = DataPluginController()
            ////            controller.when(.login) {
            ////                print("view login")
            ////            }
            //            controller.easy.when(.viewDidLoad) {
            //                print("view did load")
            //            }
            //            controller.easy.when(.dealloc) {
            //                print("view die event")
            //            }
            let controller = self.load(DataPluginController())
            controller.easy.event.when(.dealloc, block: {
                print("i die 34")
            })
            firstly {
                when(fulfilled: controller.easy.event.promise(.dealloc), controller.promise(.login))
            }.then{ [weak self] in
                self!.load(PopupController()).easy.event.promise(.dealloc)
            }.done { v in
                print("logout")
            }.ensure {
                print("die")
            }.catch { (error) in
                print(error.friendlyText)
            }
        //            self.load(controller)
        case 1:
            let controller = PopupController()
            controller.easy.event.register(event: .viewDidLoad(.before)) {
                print("view did load before 2")
            }
            controller.easy.event.register(event: .viewDidLoad(.after)) {
                print("view did load after 2")
            }
            controller.easy.event.register(event: .dealloc) {
                print("view die event")
            }
            self.load(controller)
        case 2:
            ECSetting.Alert.container.addStyle(.border(.systemBlue))
            //            ECSetting.Alert.backgroundPresentAnimation = ECPresentAnimation.FadeColor(to: .init(white: 0, alpha: 0.4))
            //            ECSetting.Alert.presentAnimation = ECPresentAnimation.Popup(anchor: .easy(1))
            
            //            ECSetting.Alert.background.addStyle(.bg(.yellow))
            //ECSetting.Alert.backgroundPresentAnimation = ECPresentAnimation.Fade()
            //                        ECSetting.Alert.presentAnimation = nil
            //            let text = NSAttributedString.easy("我是一段富文本，文本很\("富", .color(.red))，我很\("穷", .color(.green), .boldFont(size: 30))", .color(rgb: 0x333333), .font(size: 15))
            ECMessageBox.confirm(attr: "我是一段富文本，文本很\("富", .color(.red))，我很\("穷", .color(.green), .boldFont(size: 30))") { [weak self] in
                print("你点了确定")
            }
            
        case 3:
            self.page.animationView.easy.slideOut(direction: .right)
        case 4: self.load(TableViewDataSourceController())
        case 5: self.load(CollectionViewDataSourceController())
        case 6: self.load(PickerViewDataSourceController())
        case 7: self.load(PickerViewMultiDataSourceController())
        case 8:
            let provider = PickerViewDataSourceController.Provider()
            //            let keyboard = ECToolbarPickerKeyboard<PickerViewDataSourceController.Provider>(provider: provider)
            //            let keyboard = ECToolbarDatePickerKeyboard()
            //            keyboard.isHiddenForTouchBackground = true
            //            keyboard.picker.datePickerMode = .date
            //            keyboard.toolbar.titleLabel.text = "我是标题"
            //            keyboard.inputReceive = { value in
            //                print(value)
            //            }
            //            keyboard.show()
            ECPicker.create("来个列表", dataProvider: provider) { (model) in
                print(model)
            }.show()
        case 9: self.load(TextConstraintController())
        case 10: self.load(ApiController())
        case 11: self.load(TestController())
            
        default: break
        }
    }
    @objc func onDismissAnimation() {
        self.page.animationView.easy.dismiss()
    }
}
class ExampleView: ECPage {
    let tableView = UITableView()
    let animationView = UIView()
    override func load() {
        
        self.easy.add(tableView.easy(.cell(UITableViewCell.self, identifier: "Cell")), layout: .margin)
        
        self.easy.add(animationView.easy(.bg(.systemYellow), .corner(8), .hidden()), layout: .center, .size(200))
            .add(button("DismissAnimation", .text("关闭"), .bg(.systemGreen), .color(.white), .corner(4)), layout: .size(80, 44), .center)
    }
}
class PopupKeyboard: ECPopupKeyboard<String> {
    override func load() {
        self.contentView.easy.style(.bg(.green))
    }
    override func dismiss() {
        super.dismiss()
        self.input("FUCK")
    }
}
///Swift5.1: Some 泛型
///Swift5.1: @propertyWrapper
///Swift5.1: @_functionBuilder
///Swift5.2: callAsFunction 把类当方法一样调用
