//
//  ECDataView.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/13.
//

import UIKit

open class ECDataView<DataProviderType: ECDataProviderType>: UIView, ECDataControlType {
    ///数据插件
    public let dataPlugin = ECViewDataDecorator<DataProviderType>()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.load()
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.load()
    }
    open func load() {
        self.dataPlugin.targetView = self
    }
    ///加载数据
    open func loadData(completion: @escaping (Self, Result<DataProviderType.DataType, Error>) -> Void) {
        self.dataPlugin.easyData { [weak self] result in
            if let s = self {
                completion(s as! Self, result)
            }
        }
    }
    ///重新加载数据，调用前至少要调过一次loadData
    open func reloadData() {
        self.dataPlugin.reloadData()
    }
}