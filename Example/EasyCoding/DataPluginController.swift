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
    let dataManager = ECDataManager<Provider>()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.page.tableView.dataSource = self

        let refresh = ECDataRefreshPlugin<[String]>()
        let loading = ECDataLoadingPlugin<[String]>()
        let error = ECDataErrorPlugin<[String]>()
        let toast = ECDataErrorToastPlugin<[String]>()
        let empty = ECDataEmptyPlugin<[String]>()
        
        let provider = Provider()
        
        loading.targetView = self.page.tableView
        empty.targetView = self.page.tableView
        refresh.targetView = self.page.tableView
        error.targetView = self.page.tableView
    
        empty.unloadIfRequest = false
        
        toast.activate({ [weak refresh] in
            return refresh?.isRereshInited ?? false
        })
        error.activate ({ [weak refresh] in
            return !(refresh?.isRereshInited ?? true)
        })
        loading.activate { [weak refresh] () -> Bool in
            return !(refresh?.isRereshInited ?? true)
        }
        
        self.dataManager.dataProvider = provider
        self.dataManager.plugins = [loading, error, empty, toast, refresh]
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "来吧", style: .plain, target: self, action: #selector(self.onTest))
        
        
    }
    @objc func onTest() {
//        if refresh.isRereshInited {
//            loading.reloadData()
//        }else{
            self.dataManager.easyDataWithoutError { [weak self] (datas) in
                self?.datas = datas
                self?.page.tableView.reloadData()
            }
//        }
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
        
        self.easy.add(tableView.easy(.cell(UITableViewCell.self), .separator(.none)), layout: .margin(50))
    }
}

extension DataPluginController {
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
