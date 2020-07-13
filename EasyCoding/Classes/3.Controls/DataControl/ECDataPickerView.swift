//
//  ECDataPickerView.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/13.
//

import UIKit

open class ECDataPickerView<DataProviderType: ECDataListProviderType>: UIPickerView, ECDataControlType {
    ///数据源
    public let easyDataSource = ECPickerViewDataSource<DataPluginType>()
    ///数据插件
    public let dataPlugin = ECDataPluginDecorator<DataProviderType>()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.load()
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.load()
    }
    open func load() {
        self.easyDataSource.dataProvider = self.dataPlugin
        self.easyDataSource.pickerView = self
    }
    ///重新加载数据
    open func reloadDataSource() {
        self.easyDataSource.reloadData()
    }
}

//多数源插件需自己写
open class ECMultiDataPickerViewBase<FirstType: ECDataListProviderType, DataSrouceType: ECPickerViewMultiDataSourceBase<FirstType>>: UIPickerView {
    ///数据源
     public let easyDataSource = DataSrouceType()
    
     public var firstDataProvider: FirstType? {
         get {
             return self.easyDataSource.firstDataProvider
         }
         set {
             self.easyDataSource.firstDataProvider = newValue
         }
     }
     public override init(frame: CGRect) {
         super.init(frame: frame)
         self.load()
     }
     public required init?(coder: NSCoder) {
         super.init(coder: coder)
         self.load()
     }
     open func load() {
         self.easyDataSource.pickerView = self
     }
     ///重新加载数据
     open func reloadDataSource() {
         self.easyDataSource.reloadData()
     }
}
//多数源插件需自己写
open class ECDataPickerView2<FirstType: ECDataListProviderType, SecondType: ECDataListProviderType>: ECMultiDataPickerViewBase<FirstType, ECPickerViewDataSource2<FirstType, SecondType>> {
    public var secondDataProvider: SecondType? {
        get {
            return self.easyDataSource.secondDataProvider
        }
        set {
            self.easyDataSource.secondDataProvider = newValue
        }
    }
}
//多数源插件需自己写
open class ECDataPickerView3<FirstType: ECDataListProviderType, SecondType: ECDataListProviderType, ThirdType: ECDataListProviderType>: ECMultiDataPickerViewBase<FirstType, ECPickerViewDataSource3<FirstType, SecondType, ThirdType>> {
    public var secondDataProvider: SecondType? {
        get {
            return self.easyDataSource.secondDataProvider
        }
        set {
            self.easyDataSource.secondDataProvider = newValue
        }
    }
    public var thirdDataProvider: ThirdType? {
        get {
            return self.easyDataSource.thirdDataProvider
        }
        set {
            self.easyDataSource.thirdDataProvider = newValue
        }
    }
}
//多数源插件需自己写
open class ECDataPickerView4<FirstType: ECDataListProviderType, SecondType: ECDataListProviderType, ThirdType: ECDataListProviderType, FourthType: ECDataListProviderType>: ECMultiDataPickerViewBase<FirstType, ECPickerViewDataSource4<FirstType, SecondType, ThirdType, FourthType>> {
    public var secondDataProvider: SecondType? {
        get {
            return self.easyDataSource.secondDataProvider
        }
        set {
            self.easyDataSource.secondDataProvider = newValue
        }
    }
    public var thirdDataProvider: ThirdType? {
        get {
            return self.easyDataSource.thirdDataProvider
        }
        set {
            self.easyDataSource.thirdDataProvider = newValue
        }
    }
    public var fourthDataProvider: FourthType? {
        get {
            return self.easyDataSource.fourthDataProvider
        }
        set {
            self.easyDataSource.fourthDataProvider = newValue
        }
    }
}

