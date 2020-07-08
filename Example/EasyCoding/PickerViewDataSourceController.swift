//
//  PickerViewDataSourceController.swift
//  EasyCoding_Example
//
//  Created by JY_NEW on 2020/7/6.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import EasyCoding

class PickerViewDataSourceController: ECViewController<PickerViewDataSourceView> {
    let dataSource = ECPickerViewDataSource<ECViewDataDecorator<Provider>>()
    override func viewDidLoad() {
        super.viewDidLoad()
        let provider = ECViewDataDecorator<Provider>()
        provider.loading.activate(false)
        self.page.stateView.isHidden = true
        
        provider.targetView = self.page.stateView
        provider.dataProvider = Provider()
        self.dataSource.dataProvider = provider
        self.dataSource.pickerView = self.page.pickerView
        self.dataSource.cellWidthProportions = [0.5, 0.3]
        self.dataSource.actionForSelect = { model, _ , _ in
            print(model)
        }
//        provider.plugins.append(.result(success: { [weak self] (_) in
//            self?.page.stateView.isHidden = true
//        }, failure: {  [weak self] (_) in
//            self?.page.stateView.isHidden = false
//        }))
        self.dataSource.reloadData()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "设置重置", style: .plain, target: self, action: #selector(self.reset))
    }
    var models: [String]?
    @objc func reset() {
        if let models = self.models {
            self.models = nil
            self.dataSource.setSelectedModels(models)
        }else{
            self.models = self.dataSource.selectedModels
        }
    }
}
class PickerViewDataSourceView: ECPage {
    let pickerView = UIPickerView()
    let stateView = UIView()
    override func load() {
        self.easy.style(.bg(.white)).add(pickerView, layout: .top, .marginX)
            .next(stateView.easy(.bg(.white)), layout: .margin)
    }
}
extension PickerViewDataSourceController {
    class Provider: ECDataListProviderType {
        typealias SectionType = String
        typealias ModelType = String
        typealias DataType = [String]
        
        func easyData(completion: @escaping (Result<[String], Error>) -> Void) {
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
                completion(.success(["我也A","我也B","我也C","我也D"]))
//                completion(.failure(ECDataError<DataType>("oh no")))
            }
        }
        
        func sections(for data: [String]) -> [String]? {
            return ["1","2", "3", "4"]
        }
        func lists(for data: [String]) -> [[String]] {
            return [data, data, data, data]
        }
        func indexTitles(for data: [String]) -> [String]? {
            return ["1", "2", "4"]
        }
        func indexPathForIndexTitle(_ title: String, at index: Int) -> IndexPath {
            if index > 2 {
                return IndexPath(row: 0, section: 3)
            }else{
                return IndexPath(row: 0, section: index)
            }
        }
    }
}
