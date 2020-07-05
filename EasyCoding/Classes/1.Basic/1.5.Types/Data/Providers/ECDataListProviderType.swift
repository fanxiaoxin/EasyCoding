//
//  ECDataListProviderType.swift
//  EasyCoding
//
//  Created by 范晓鑫 on 2020/7/5.
//

import UIKit

///列表数据，可用于TableView或CollectionView的数据源
public protocol ECDataListProviderType: ECDataProviderType {
    associatedtype SectionType
    associatedtype ItemType
    ///汇总对象
    func sections(for data: DataType) -> [SectionType]?
    ///列表数据
    func lists(for data: DataType) -> [[ItemType]]
    ///汇总对象
    func section(for data: DataType) -> SectionType?
    ///列表数据
    func list(for data: DataType) -> [ItemType]
}
extension ECDataListProviderType {
    ///汇总对象
    public func sections(for data: DataType) -> [SectionType]? {
        if let section = self.section(for: data) {
            return [section]
        }
        return nil
    }
    ///列表数据
    public func lists(for data: DataType) -> [[ItemType]] {
        return [self.list(for: data)]
    }
    ///汇总对象
    public func section(for data: DataType) -> SectionType? {
        return nil
    }
    ///列表数据
    public func list(for data: DataType) -> [ItemType] {
        return []
    }
}

///默认所有装饰器都可直接装饰该类型
extension ECDataPagedProviderType where Self: ECDataProviderDecoratorType, DataProviderType: ECDataListProviderType, DataProviderType.DataType == DataType {
    ///汇总对象
    public func sections(for data: DataType) -> [DataProviderType.SectionType]? {
        return self.dataProvider?.sections(for: data)
    }
    ///列表数据
    public func lists(for data: DataType) -> [[DataProviderType.ItemType]] {
        return self.dataProvider?.lists(for: data) ?? [[]]
    }
    ///汇总对象
    public func section(for data: DataType) -> DataProviderType.SectionType? {
        return self.dataProvider?.section(for: data)
    }
    ///列表数据
    public func list(for data: DataType) -> [DataProviderType.ItemType] {
        return self.dataProvider?.list(for: data) ?? []
    }
}

///所有的数组都默认为列表对象
extension Array: ECDataListProviderType {
    public typealias SectionType = String
    public typealias ItemType = Element
    ///汇总对象
    public func section(for data: DataType) -> SectionType? {
        return nil
    }
    ///列表数据
    public func list(for data: DataType) -> [ItemType] {
        return self
    }
}

///列表数据控件
public protocol ECListDataControlType {
    associatedtype DataProviderType: ECDataListProviderType
    var dataProvider: DataProviderType? { get set }
}
