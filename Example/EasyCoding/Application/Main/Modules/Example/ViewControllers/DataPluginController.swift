//
//  DataPluginController.swift
//  EasyCoding_Example
//
//  Created by JY_NEW on 2020/7/1.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import EasyCoding

class DataPluginController: ViewController<DataPluginView>, UITableViewDataSource {
    override var preconditions: [ECViewControllerCondition]? {
        return [.example]
    }
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

protocol TEST3: ECDataProviderType {
    var haha: String {get set}
    func xx()
}
extension ECDataProviderDecoratorType where DataProviderType: TEST3 {
    var haha: String {
        get {  return self.dataProvider?.haha ?? "" }
        set { self.dataProvider?.haha = newValue }
    }
    func xx() {
        self.dataProvider?.xx()
    }
}
extension ECDataPluginDecorator : TEST3 where DataProviderType: TEST3 {
    
}
class KK: TEST3, ECDataPagedProviderType {
    var page: Int = 1
    
    func merge(data1: String, data2: String) -> String {
        return ""
    }
    
    func easyData(completion: @escaping (Result<String, Error>) -> Void) {
        
    }
    
    typealias DataType = String
    
    var haha: String = ""
    
    func xx() {
        
    }
    
    
}
func xx<T: TEST3>(_ xx: T) {
    
}
func bb() {
    xx(KK())
    xx(ECDataPagedDecorator<KK>())
    
}
extension DataPluginController {
    class Provider: ECDataPagedProviderType, ECDataListProviderType {
        typealias SectionType = String
        
        typealias ModelType = String
        
        var page: Int = 1
        func list(for data: [String]) -> [String] {
            return data
        }
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
        func isLastPage(for data: DataType) -> Bool {
            return page >= 5
        }
    }

}
