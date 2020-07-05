//
//  ECDataListProviderType.swift
//  EasyCoding
//
//  Created by 范晓鑫 on 2020/7/5.
//

import UIKit

///列表数据，可用于TableView或CollectionView的数据源
public protocol ECDataListProviderType : ECDataProviderType {
   
}
///列表数据控件
public protocol ECListDataControlType {
    associatedtype DataProviderType: ECDataProviderType
    associatedtype SectionType
    associatedtype ItemType
    var dataProvider: DataProviderType? { get set }
    ///从获取到的数据提取章节列表
    var sectionTransform: ((DataProviderType.DataType) -> [SectionType]) { get set }
    ///从获取到的数据根据章节索引提取数据列表
    var itemTransform: ((DataProviderType.DataType, _ section: Int) -> [ItemType]) { get set }
    init()
}
extension ECListDataControlType {
    public init(section sectionTransform: @escaping (DataProviderType.DataType) -> [SectionType],
                item itemTransform: @escaping (DataProviderType.DataType, Int) -> [ItemType]) {
        self.init()
        self.sectionTransform = sectionTransform
        self.itemTransform = itemTransform
    }
}
public class haha<DataProviderType: ECDataProviderType, SectionType, ItemType>: UITableView, ECListDataControlType {
    public required init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var dataProvider: DataProviderType?
    
    public var sectionTransform: ((DataProviderType.DataType) -> [SectionType])
    
    public var itemTransform: ((DataProviderType.DataType, Int) -> [ItemType])
    
}

///章节数据
public protocol ECListDataType: ECDataType {
    associatedtype SectionType
    associatedtype ItemType
    ///汇总对象
    var sections: [SectionType]? { get }
    ///列表数据
    var datas: [[ItemType]]? { get }
    ///汇总对象
    var section: SectionType? { get }
    ///列表数据
    var items: [ItemType]? { get }
}
extension ECListDataType {
    ///汇总对象
    var sections: [SectionType]? {
        if let section = self.section {
            return [section]
        }
        return nil
    }
    ///列表数据
    var datas: [[ItemType]]? {
        if let items = self.items {
            return [items]
        }
        return nil
    }
    ///汇总对象
    var section: [SectionType]? { return nil }
    ///列表数据
    var items: [ItemType]? { return nil }
}
/*
func xx() {
    let a = ["",""]
    let idxs = a.map { (s) -> Int in
        s.count
    }
    let idxs2 = a.map(\.count)
    let f = ffff()
    let i = f.per2(\.count)
    
    let h = haha<[String], Int, Bool>(section: \.count, item: \.isEmpty)

}
class ffff {
    var per: ((String) -> Int)?
    func per2(_ transform: (String) -> Int) -> Int {
        
    }
}

///列表数据
public protocol ECListDataType: ECListDataGroupType {
    ///所有的数据
    var datas: [SectionDataType]? { get }
}
///所有的数组都默认为章节对象
extension Array: ECSectionDataType {
    public typealias SectionType = ECNull
    public typealias ItemType = Element
    
    public var section: ECNull? { return nil }
    public var items: [Element]? { return self }
}
extension ECListDataType {
    ///章节对象
    var section: SectionDataType.SectionType? { return self.sections?.first?.section }
    ///列表数据
    var items: [SectionDataType.ItemType]? { return self.sections?.first?.items }
}
///所有的数组都可直接当列表对象
extension Array: ECListDataType {
    public typealias SectionDataType = Array<Element>
    
    public var sections: [Array<Element>]? { return [self] }
}
*/
