//
//  EasyDataPickerView.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/13.
//
#if EASY_DATA

import UIKit

open class EasyDataPickerView<DataProviderType: EasyDataListProviderType>: UIPickerView, EasyDataControlType {
    ///数据源
    public let easyDataSource = EasyPickerViewDataSource<DataPluginType>()
    ///数据插件
    public let dataPlugin = EasyDataPluginDecorator<DataProviderType>()
    
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
open class EasyMultiDataPickerViewBase<FirstType: EasyDataListProviderType, DataSrouceType: EasyPickerViewMultiDataSourceBase<FirstType>>: UIPickerView {
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
open class EasyDataPickerView2<FirstType: EasyDataListProviderType, SecondType: EasyDataListProviderType>: EasyMultiDataPickerViewBase<FirstType, EasyPickerViewDataSource2<FirstType, SecondType>> {
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
open class EasyDataPickerView3<FirstType: EasyDataListProviderType, SecondType: EasyDataListProviderType, ThirdType: EasyDataListProviderType>: EasyMultiDataPickerViewBase<FirstType, EasyPickerViewDataSource3<FirstType, SecondType, ThirdType>> {
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
open class EasyDataPickerView4<FirstType: EasyDataListProviderType, SecondType: EasyDataListProviderType, ThirdType: EasyDataListProviderType, FourthType: EasyDataListProviderType>: EasyMultiDataPickerViewBase<FirstType, EasyPickerViewDataSource4<FirstType, SecondType, ThirdType, FourthType>> {
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

#endif
