//
//  EasyDataScrollView.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/13.
//
#if EASY_DATA

import UIKit

open class EasyDataScrollView<DataProviderType: EasyDataProviderType>: UIScrollView, EasyDataScrollViewType {
    ///数据插件
    public var dataPlugin: EasyDataPluginDecorator<DataProviderType>?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.load()
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.load()
    }
    open func load() {
        
    }
    ///加载数据
    open func loadData(completion: @escaping (Self, Result<DataProviderType.DataType, Error>) -> Void) {
        self.dataPlugin?.easyData { [weak self] result in
            if let s = self {
                completion(s as! Self, result)
            }
        }
    }
    ///加载数据
    open func loadDataWithoutError(completion: @escaping (Self, DataProviderType.DataType) -> Void) {
        self.dataPlugin?.easyData { [weak self] result in
            if let s = self {
                switch result {
                case let .success(data):
                completion(s as! Self, data)
                default: break
                }
            }
        }
    }
    ///重新加载数据，调用前至少要调过一次loadData
    open func reloadData() {
        self.dataPlugin?.reloadData()
    }
}

#endif
