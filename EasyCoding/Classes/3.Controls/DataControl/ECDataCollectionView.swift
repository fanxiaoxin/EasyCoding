//
//  ECDataCollectionView.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/13.
//

import UIKit

open class ECDataCollectionView<DataProviderType: ECDataListProviderType>: UICollectionView, ECDataScrollViewType {
    ///数据源
    public let easyDataSource = ECCollectionViewDataSource<ECDataPluginDecorator<DataProviderType>>()
    ///数据插件
    public var dataPlugin: ECDataPluginDecorator<DataProviderType>? {
        didSet {
            self.easyDataSource.dataProvider = self.dataPlugin
        }
    }
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.load()
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.load()
    }
    open func load() {
        self.easyDataSource.collectionView = self
    }
    ///重新加载数据
    open func reloadDataSource() {
        self.easyDataSource.reloadData()
    }
}
