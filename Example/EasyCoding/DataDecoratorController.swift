//
//  ExampleController.swift
//  EasyCoding_Example
//
//  Created by JY_NEW on 2020/6/30.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import EasyCoding

class DataDecoratorController: ECViewController<DataDecoratorView>, UITableViewDataSource {
    let error = ECDataErrorDecorator<[String]>()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.page.tableView.dataSource = self

        let refresh = ECDataRefreshDecorator<[String]>()
        let toast = ECDataErrorToastDecorator<[String]>()
        let empty = ECDataEmptyDecorator<[String]>()
        let loading = ECDataLoadingDecorator<[String]>()
        let provider = Provider()
        
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
    @objc func onTest() {
        error.easyDataWithoutError { [weak self] (datas) in
            self?.datas = datas
            self?.page.tableView.reloadData()
        }
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
class DataDecoratorView: ECPage {
    let tableView = UITableView()
    
    override func load() {
        self.backgroundColor = .white
        
        self.easy.add(tableView.easy(.cell(UITableViewCell.self), .separator(.none)), layout: .margin(50))
    }
}
extension DataDecoratorController {
    class Provider: ECDataProviderType {
        typealias DataType = [String]
        var count = 0
        func easyData(completion: @escaping (Result<DataType, Error>) -> Void) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                //            completion(.success(["aa","BBBBB"]))
                //            completion(.success([]))
                if let s = self {
                    if s.count < 2 || s.count.in(4,5) {
                        completion(.failure(ECDataError<DataType>("我是一个错")))
                    }else if s.count.in(8,9 ){
                        completion(.success([]))
                    }else{
                        completion(.success(["aa","BBBBB"]))
                    }
                    s.count += 1
                }
            }
        }
        deinit {
            print("P die")
        }
    }

}
