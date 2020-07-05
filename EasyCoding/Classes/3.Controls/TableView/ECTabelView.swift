//
//  ECTabelView.swift
//  EasyCoding
//
//  Created by 范晓鑫 on 2020/7/5.
//

import UIKit

open class ECTabelView<DataProviderType: ECDataProviderType>: UITableView, UITableViewDataSource {
    ///数据源
    open var dataProvider: DataProviderType?
    ///用于保存用户自定义的DataSource
    fileprivate var __userDataSource: UITableViewDataSource?
    open override var dataSource: UITableViewDataSource? {
        get {
            return __userDataSource
        }
        set {
            __userDataSource = newValue
        }
    }
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.load()
    }
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.load()
    }
    open func load() {
        super.dataSource = self
    }
    
    // MARK: Section
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.__userDataSource?.numberOfSections?(in: tableView) ?? 0
    }
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return self.__userDataSource?.tableView?(tableView, titleForHeaderInSection: section)
    }
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return self.__userDataSource?.tableView?(tableView, titleForFooterInSection: section)
    }
    
    // MARK: Cell
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.__userDataSource?.tableView(tableView, numberOfRowsInSection: section) ?? 0
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.__userDataSource?.tableView(tableView, cellForRowAt: indexPath) ?? UITableViewCell()
    }
    
    // MARK: Indexs
    
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.__userDataSource?.sectionIndexTitles?(for: tableView)
    }
    public func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return self.__userDataSource?.tableView?(tableView, sectionForSectionIndexTitle: title, at: index) ?? index
    }
    
    // MARK: Edit & Move
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return self.__userDataSource?.tableView?(tableView, canEditRowAt: indexPath) ?? false
    }
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return self.__userDataSource?.tableView?(tableView, canMoveRowAt: indexPath) ?? false
    }
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.__userDataSource?.tableView?(tableView, commit: editingStyle, forRowAt: indexPath)
    }
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        self.__userDataSource?.tableView?(tableView, moveRowAt: sourceIndexPath, to: destinationIndexPath)
    }
    
}

open class ECCollectionView: UICollectionView, UICollectionViewDataSource {
    
    // MARK: Section
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 0
    }
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return UICollectionReusableView()
    }
    
    // MARK: Cell
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    // MARK: Indexs
    
    open func indexTitles(for collectionView: UICollectionView) -> [String]? {
        return nil
    }
    open func collectionView(_ collectionView: UICollectionView, indexPathForIndexTitle title: String, at index: Int) -> IndexPath {
        return IndexPath()
    }
    
    // MARK: Move
    
    open func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    open func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
}
