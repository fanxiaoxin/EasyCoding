//
//  EasyListControlDataSource.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/6.
//
#if EASY_DATA

import UIKit

open class EasyListControlDataSource<DataProviderType: EasyDataListProviderType>: NSObject {
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
    ///数据加载完成事件，若有需要在数据加载完后执行的操作可直接添加进来，执行过一次就会删除
    public let whenDataLoaded = EasyOnceEvent()

    /// 刷新数据，请求数据并刷新显示
    open func reloadData() {
        self.dataProvider?.easyDataWithoutError { [weak self] (data) in
            if let s = self, let provider = s.dataProvider {
                s.sections = provider.sections(for: data)
                s.datas = provider.lists(for: data)
                s.indexTitles = provider.indexTitles(for: data)
                s.whenDataLoaded()
                s.refreshControl()
            }
        }
    }
    ///刷新控件显示
    open func refreshControl() {
        
    }
}

#endif
