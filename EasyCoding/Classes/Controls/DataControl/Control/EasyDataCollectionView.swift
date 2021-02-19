//
//  EasyDataCollectionView.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/13.
//

#if EASY_DATA

import UIKit

open class EasyDataCollectionView<DataProviderType: EasyDataListProviderType>: UICollectionView, EasyDataScrollViewType {
    ///数据源
    public let easyDataSource = EasyCollectionViewDataSource<EasyDataPluginDecorator<DataProviderType>>()
    ///数据插件
    public var dataPlugin: EasyDataPluginDecorator<DataProviderType>? {
        didSet {
            self.easyDataSource.dataProvider = self.dataPlugin
        }
    }
    public init(_ layoutStyles: EasyStyleSetting<EasyCollectionViewFixedColumnsLayout>) {
        let layout = EasyCollectionViewFixedColumnsLayout.easy(layoutStyles)
        super.init(frame: .zero, collectionViewLayout: layout)
        self.load()
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

#endif
