//
//  ExampleController.swift
//  EasyCoding_Example
//
//  Created by JY_NEW on 2020/6/30.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import EasyCoding

class ExampleController: ECViewController<ExampleView>, UITableViewDataSource {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.page.tableView.dataSource = self
        

        let toast = ECDataErrorToastDecorator<[String]>()
        let empty = ECDataEmptyDecorator<[String]>()
        let loading = ECDataLoadingDecorator<[String]>()
        let provider = P()
        
        loading.targetView = self.page.tableView
        empty.targetView = self.page.tableView
        refresh.targetView = self.page.tableView
        error.targetView = self.page.tableView

        empty.set(provider: provider)
        toast.set(provider: empty)
        refresh.set(provider: toast)
        loading.set(provider: refresh)
        error.set(provider: loading)
               
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "来吧", style: .plain, target: self, action: #selector(self.onTest))
        
        
    }
    let error = ECDataErrorDecorator<[String]>()
    let refresh = ECDataRefreshDecorator<[String]>()
    @objc func onTest() {
        //        ECAlertConfig.default.message.addStyle(.boldFont(size: 20))
        //        ECAlertConfig.default.input.addStyle(.bg(.green))
        //        ECAlertConfig.default.input.layout(.margin(180, 0, 150, 0))
        //        ECMessageBox.confirm(title: "看这个标题", attr: "try metry \("trye3 ry metrry metr", .color(.red), .boldFont(size: 24)) metry metry metry me") { [weak self] in
        //            //自定义视图
        //            //自定义列表，可多组，可异步
        //            //日期
        //        }
        refresh.reloadCompletion = { [weak self] (result) in
            switch result {
            case let .success(datas):
                self?.datas = datas
                self?.page.tableView.reloadData()
            default: break
            }
        }
        error.reloadCompletion = refresh.reloadCompletion
        error.reloadData()
    }
    var datas: [String]?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datas?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Default")!
        cell.textLabel?.text = self.datas?[indexPath.row]
        return cell
    }
}
class ExampleView: ECPage {
    let tableView = UITableView()
    
    override func load() {
        self.backgroundColor = .white
        
        self.easy.add(tableView.easy(.cell(UITableViewCell.self), .separator(.none)), layout: .margin(50))
    }
}
