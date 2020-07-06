//
//  ECListControlDataSource.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/6.
//

import UIKit

open class ECListControlDataSource<DataProviderType: ECDataListProviderType>: NSObject {
    public typealias SectionType = DataProviderType.SectionType
    public typealias ModelType = DataProviderType.ModelType
    ///数据源
    open var dataProvider: DataProviderType?
    ///Section数据
    open var sections: [SectionType]?
    ///Section索引
    open var indexTitles: [String]?
    ///列表数据
    open var datas: [[ModelType]]?

    /// 刷新数据，请求数据并刷新显示
    open func reloadData() {
        self.dataProvider?.easyDataWithoutError { [weak self] (data) in
            if let s = self, let provider = s.dataProvider {
                s.sections = provider.sections(for: data)
                s.datas = provider.lists(for: data)
                s.indexTitles = provider.indexTitles(for: data)
                s.refreshControl()
            }
        }
    }
    ///刷新控件显示
    open func refreshControl() {
        
    }
}
