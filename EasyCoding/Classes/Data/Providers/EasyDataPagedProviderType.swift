//
//  EasyDataPagedProviderType.swift
//  EasyCoding
//
//  Created by 范晓鑫 on 2020/7/5.
//

import UIKit

///分页数据
public protocol EasyDataPagedProviderType : EasyDataProviderType {
    ///首页的值，可用于重置下拉刷新或者判断是否刷新
    var firstPage: Int { get }
    ///设置页码
    var page: Int { get set }
    ///是否最后一页，若当前为最后一页则没有下拉加载新的页数
    func isLastPage(for data: DataType) -> Bool
    ///整合两个数据，用于加载下一页时跟上一页进行合并
    func merge(data1: DataType, data2: DataType) -> DataType
}
extension EasyDataPagedProviderType {
    ///第一页的值，默认为1
    public var firstPage: Int { return 1 }
    ///是否第一页，若当前为第1页则说明是刷新数据
    public var isFirstPage: Bool { return self.page == self.firstPage }
    ///是否最后一页，若当前为最后一页则没有下拉加载新的页数
    public func isLastPage(for data: DataType) -> Bool { return true }
}
///默认所有装饰器都可直接装饰该类型
extension EasyDataPagedProviderType where Self: EasyDataProviderDecoratorType, DataProviderType: EasyDataPagedProviderType, DataProviderType.DataType == DataType {
    ///首页的值，可用于重置下拉刷新或者判断是否刷新
    public var firstPage: Int { return self.dataProvider?.firstPage ?? 1 }
    ///设置页码
    public var page: Int {
        get {
            return self.dataProvider?.page ?? self.firstPage
        }
        set {
            self.dataProvider?.page = newValue
        }
    }
    ///是否最后一页，若当前为最后一页则没有下拉加载新的页数
    public func isLastPage(for data: DataType) -> Bool { self.dataProvider?.isLastPage(for: data) ?? true }
    ///整合两个数据，用于加载下一页时跟上一页进行合并
    public func merge(data1: DataType, data2: DataType) -> DataType {
        return self.dataProvider?.merge(data1: data1, data2: data2) ?? data1
    }
}
