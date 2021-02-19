//
//  EasyCollectionViewDataSource.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/6.
//
#if EASY_DATA

import UIKit

open class EasyCollectionViewCell<ModelType>: UICollectionViewCell {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.load()
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.load()
    }
    ///初始化方法
    open func load() { }
    ///加载模型数据
    open func load(model: ModelType, indexPath: IndexPath) { }
}
open class EasyCollectionSupplementaryView<SectionType>: UICollectionReusableView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.load()
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.load()
    }
    ///初始化方法
    open func load() { }
    ///加载模型数据
    open func load(model: SectionType, indexPath: IndexPath) { }
}
///CollectionView需事先注册后Cell
open class EasyCollectionViewDataSource<DataProviderType: EasyDataListProviderType>: EasyListControlDataSource<DataProviderType>, UICollectionViewDataSource {
    ///当前操作的tableView
    open weak var collectionView: UICollectionView? {
        didSet {
            self.collectionView?.dataSource = self
            self.collectionView?.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "__EasyCoding.Null")
        }
    }
    ///设置Cell的类型对应的identifier，默认为Default
    open var identifierForCell: (ModelType, IndexPath) -> String = { _, _ in "Default" }
    ///设置SectionHeader的View的identifier
    open var identifierForHeader: (SectionType, IndexPath) -> String? = { _, _ in "Default" }
    ///设置SectionFooter的View的identifier
    open var identifierForFooter: (SectionType, IndexPath) -> String? = { _, _ in "Default" }

    ///设置移动事件
    open var actionForMove: ((UICollectionView, IndexPath, IndexPath) -> Void)?
    
    ///获取选中的数据
    open var selectedModels:[ModelType]? {
        if let datas = self.datas, let collection = self.collectionView, let indexPaths = collection.indexPathsForSelectedItems {
            var models:[ModelType] = []
            for indexPath in indexPaths {
                models.append(datas[indexPath.section][indexPath.row])
            }
            return models
        }
        return nil
    }
    
    open override func refreshControl() {
        self.collectionView?.reloadData()
    }
    
    // MARK: Section
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.datas?.count ?? 0
    }
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let model = self.sections?[indexPath.section] {
            if let identifier = self.identifierForHeader(model, indexPath) {
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier, for: indexPath) as! EasyCollectionSupplementaryView<SectionType>
                view.load(model: model, indexPath: indexPath)
                return view
            }else if let identifier = self.identifierForFooter(model, indexPath) {
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: identifier, for: indexPath) as! EasyCollectionSupplementaryView<SectionType>
                view.load(model: model, indexPath: indexPath)
                return view
            }
        }
        return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "__EasyCoding.Null", for: indexPath)
    }
    
    // MARK: Cell
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.datas?[section].count ?? 0
    }
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let model = self.datas?[indexPath.section][indexPath.row] {
            let identifier = self.identifierForCell(model, indexPath)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! EasyCollectionViewCell<ModelType>
            
            cell.load(model: model, indexPath: indexPath)
            
            return cell
        }
        fatalError("没有数据")
    }
    
    // MARK: Indexs
    
    open func indexTitles(for collectionView: UICollectionView) -> [String]? {
        return self.indexTitles
    }
    open func collectionView(_ collectionView: UICollectionView, indexPathForIndexTitle title: String, at index: Int) -> IndexPath {
        return self.dataProvider?.indexPathForIndexTitle(title, at: index) ?? IndexPath(row: 0, section: 0)
    }
    
    // MARK: Move
    
    open func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return  self.actionForMove != nil
    }
    open func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
         self.actionForMove?(collectionView, sourceIndexPath, destinationIndexPath)
    }
}

extension EasyCoding where Base: UICollectionView {
    ///创建Easy数据源
    public func createDataSource<DataProviderType: EasyDataProviderType>(provider: DataProviderType) -> EasyCollectionViewDataSource<DataProviderType> {
        let dataSource = EasyCollectionViewDataSource<DataProviderType>()
        dataSource.dataProvider = provider
        dataSource.collectionView = self.base
        return dataSource
    }
}

#endif
