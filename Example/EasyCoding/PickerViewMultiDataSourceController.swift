//
//  PickerViewMultiDataSourceController.swift
//  EasyCoding_Example
//
//  Created by JY_NEW on 2020/7/7.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

import EasyCoding

class PickerViewMultiDataSourceController: ECViewController<PickerViewDataSourceView> {
    let dataSource = ECPickerViewDataSource3<Provider, Provider, Provider>()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.page.stateView.isHidden = true
        
        let provider = Provider()
        
        self.dataSource.firstDataProvider = provider
        self.dataSource.secondDataProvider = provider
        self.dataSource.thirdDataProvider = provider
        
//        self.dataSource.viewForThirdCell = { Cell() }
        
        self.dataSource.prepareForSecondData = { first, provider in
            provider.start = first
        }
//        self.dataSource.prepareForThirdData = { second, provider in
//            provider.start = second
//        }

        self.dataSource.pickerView = self.page.pickerView
        self.dataSource.cellWidthProportions = [0.5, 0.3]
//        self.dataSource.actionForThirdSelect = { [weak self] model, _ in
//            print(self?.dataSource.selectedModels)
//            print(model)
//        }
        
        self.dataSource.reloadData()
    }
}
extension PickerViewMultiDataSourceController {
    class Provider: ECDataListProviderType {
        typealias SectionType = String
        typealias ModelType = String
        typealias DataType = [String]
        
        var start: String = "A"
        func easyData(completion: @escaping (Result<[String], Error>) -> Void) {
            let start = self.start
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
                completion(.success([start + "1",start + "2",start + "3",start + "4"]))
//                completion(.failure(ECDataError<DataType>("oh no")))
            }
        }
        
        func lists(for data: [String]) -> [[String]] {
            return [data, data]
        }
    }
    class Cell: ECPickerViewCell<String> {
        let label = UILabel()
        override func load() {
            self.easy.add(label.easy(.color(.blue), .font(UIFont.easy.pingfang(bold: 18))), layout: .center)
        }
        override func load(model: String, component: Int, row: Int) {
            self.label.text = "\(row):\(model)"
        }
    }
}
