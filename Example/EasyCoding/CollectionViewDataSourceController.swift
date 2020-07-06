//
//  CollectionViewDataSourceController.swift
//  EasyCoding_Example
//
//  Created by JY_NEW on 2020/7/6.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import EasyCoding

class CollectionViewDataSourceController: ECViewController<CollectionViewDataSourceView> {
    let dataSource = ECCollectionViewDataSource<ECViewDataRefreshDecorator<Provider>>()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let provider = ECViewDataRefreshDecorator<Provider>()
        provider.dataProvider = Provider()
        provider.targetView = self.page.collectionView
        self.dataSource.dataProvider = provider
        self.dataSource.collectionView = self.page.collectionView
        
        self.dataSource.reloadData()
    }
}
class CollectionViewDataSourceView: ECPage {
    let layout = UICollectionViewFlowLayout()
    @ECProperty.DelayInit
    var collectionView: UICollectionView
    override func load() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.easy.add(collectionView.easy(.bg(.white), .cell(CollectionViewDataSourceCell.self), .header(CollectionViewDataSourceHeader.self)), layout: .margin)
        layout.headerReferenceSize = .easy(UIScreen.main.bounds.size.width, 100)
    }
}
class CollectionViewDataSourceCell: ECCollectionViewCell<String> {
    let textLabel = UILabel()
    override func load() {
        self.easy.add(textLabel, layout: .margin)
    }
    override func load(model: String, indexPath: IndexPath) {
        self.textLabel.text = model
    }
}
class CollectionViewDataSourceHeader: ECCollectionSupplementaryView<String> {
    let textLabel = UILabel()
    override func load() {
        self.easy.add(textLabel.easy(.color(.red)), layout: .margin)
    }
    override func load(model: String, indexPath: IndexPath) {
        self.textLabel.text = model
    }
}


extension CollectionViewDataSourceController {
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
