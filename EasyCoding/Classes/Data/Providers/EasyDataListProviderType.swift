//
//  EasyDataListProviderType.swift
//  EasyCoding
//
//  Created by 范晓鑫 on 2020/7/5.
//

import UIKit

///列表数据，可用于TableView或CollectionView的数据源
public protocol EasyDataListProviderType: EasyDataProviderType {
    associatedtype SectionType
    associatedtype ModelType
    ///汇总对象
    func sections(for data: DataType) -> [SectionType]?
    ///列表数据
    func lists(for data: DataType) -> [[ModelType]]
    ///汇总对象
    func section(for data: DataType) -> SectionType?
    ///列表数据
    func list(for data: DataType) -> [ModelType]
    ///建立索引
    func indexTitles(for data: DataType) -> [String]?
    ///引导索引
    func indexPathForIndexTitle(_ title: String, at index: Int) -> IndexPath
}
extension EasyDataListProviderType {
    ///汇总对象
    public func sections(for data: DataType) -> [SectionType]? {
        if let section = self.section(for: data) {
            return [section]
        }
        return nil
    }
    ///列表数据
    public func lists(for data: DataType) -> [[ModelType]] {
        return [self.list(for: data)]
    }
    ///汇总对象
    public func section(for data: DataType) -> SectionType? {
        return nil
    }
    ///列表数据
    public func list(for data: DataType) -> [ModelType] {
        return []
    }
    ///建立索引
    public func indexTitles(for data: DataType) -> [String]? {
        return nil
    }
    ///引导索引
    public func indexPathForIndexTitle(_ title: String, at index: Int) -> IndexPath {
        return IndexPath(row: 0, section: 0)
    }
}

///默认所有装饰器都可直接装饰该类型
extension EasyDataListProviderType where Self: EasyDataProviderDecoratorType, DataProviderType: EasyDataListProviderType, DataProviderType.DataType == DataType {
    ///汇总对象
    public func sections(for data: DataType) -> [DataProviderType.SectionType]? {
        return self.dataProvider?.sections(for: data)
    }
    ///列表数据
    public func lists(for data: DataType) -> [[DataProviderType.ModelType]] {
        return self.dataProvider?.lists(for: data) ?? [[]]
    }
    ///汇总对象
    public func section(for data: DataType) -> DataProviderType.SectionType? {
        return self.dataProvider?.section(for: data)
    }
    ///列表数据
    public func list(for data: DataType) -> [DataProviderType.ModelType] {
        return self.dataProvider?.list(for: data) ?? []
    }
    ///建立索引
    public func indexTitles(for data: DataType) -> [String]? {
        return self.dataProvider?.indexTitles(for: data)
    }
    ///引导索引
    public func indexPathForIndexTitle(_ title: String, at index: Int) -> IndexPath {
        return self.dataProvider?.indexPathForIndexTitle(title, at: index) ?? IndexPath(row: 0, section: 0)
    }
}

extension EasyDataListProviderType where DataType == [ModelType] {
    ///列表数据
    public func list(for data: DataType) -> [ModelType] {
        return data
    }
}
extension EasyDataListProviderType where DataType == [[ModelType]] {
    ///列表数据
    public func lists(for data: DataType) -> [[ModelType]] {
        return data
    }
}
///所有的数组都默认为列表对象
extension Array: EasyDataListProviderType {
    public typealias SectionType = EasyNull
    public typealias ModelType = Element
}
