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
        provider.targetView = self.page.pickerView
        provider.dataProvider = Provider()
        self.dataSource.dataProvider = provider
        self.dataSource.pickerView = self.page.pickerView
        self.dataSource.cellWidthProportions = [0.5, 0.3]
        self.dataSource.actionForSelect = { model, _ , _ in
            print(model)
        }
        
        self.dataSource.reloadData()
    }
}
class PickerViewDataSourceView: ECPage {
    let pickerView = UIPickerView()
    override func load() {
        self.easy.style(.bg(.yellow)).add(pickerView.easy(.bg(.green)), layout: .top, .marginX)
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
