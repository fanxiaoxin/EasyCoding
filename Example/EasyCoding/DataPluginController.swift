//
//  DataPluginController.swift
//  EasyCoding_Example
//
//  Created by JY_NEW on 2020/7/1.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import EasyCoding

class DataPluginController: ECViewController<DataPluginView>, UITableViewDataSource {
//    let dataProvider = ECViewDataDecorator<Provider>()
//    let dataProvider = ECViewDataRefreshDecorator<Provider>()
    let dataProvider = ECViewDataPagedDecorator<Provider>()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.page.tableView.dataSource = self
        let provider = Provider()
        self.dataProvider.dataProvider = provider
        self.dataProvider.targetView = self.page.tableView
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "来吧", style: .plain, target: self, action: #selector(self.onTest))
    }
    @objc func onTest() {
        self.dataProvider.easyDataWithoutError { [weak self] (datas) in
            self?.datas = datas
            self?.page.tableView.reloadData()
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print(self.page.tableView.frame)
        print(UIView.easy.safeArea)
        if #available(iOS 11.0, *) {
            print(self.page.tableView.safeAreaInsets)
        } else {
            // Fallback on earlier versions
        }
        print(self.page.tableView.scrollIndicatorInsets)
        
        print(self.page.tableView.contentInset)
        
        
        
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
class DataPluginView: ECPage {
    let tableView = UITableView()
    
    override func load() {
        self.backgroundColor = .white
        
        self.easy.add(tableView.easy(.cell(UITableViewCell.self), .separator(.none)), layout: .margin)
    }
}

extension DataPluginController {
    class Provider: ECDataPagedProviderType {
        var page: Int = 1
        
        func merge(data1: [String], data2: [String]) -> [String] {
            var data = data1
            data.append(contentsOf: data2)
            return data
        }
        
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
        var isLastPage: Bool {
            return page >= 5
        }
        deinit {
            print("P die")
        }
    }

}
