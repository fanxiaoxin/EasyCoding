//
//  EasyToolbarPickerKeyboard.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/7.
//

import UIKit

///选择器配置
public struct EasyToolbarPickerKeyboardConfig {
    ///日期选择器
    public static let datePicker = EasyControlConfig<UIDatePicker>(styles: [], layouts: [.margin])
    ///选择器
    public static let picker = EasyControlConfig<UIPickerView>(styles: [], layouts: [.margin])
}
//扩展EasyToolbarKeyboardConfig，简化使用复杂度，统一在EasyToolbarKeyboardConfig里配置
extension EasyToolbarKeyboardConfig {
    public var datePicker: EasyControlConfig<UIDatePicker> {
        return EasyToolbarPickerKeyboardConfig.datePicker
    }
    public var picker: EasyControlConfig<UIPickerView> {
        return EasyToolbarPickerKeyboardConfig.picker
    }
}
///日期选择器
open class EasyToolbarDatePickerKeyboard: EasyToolbarKeyboard<Date> {
    open var picker = UIDatePicker()
    open override func load() {
        super.load()
        
        self.contentView.addSubview(self.picker)
        EasyToolbarPickerKeyboardConfig.datePicker.apply(for: self.picker)
    }
    open override func currentValue() -> Date? {
        return self.picker.date
    }
}
//通用选择器
open class EasyToolbarPickerKeyboardBase<InputType>: EasyToolbarKeyboard<InputType> {
    open var picker = UIPickerView()
    open override func load() {
        super.load()
        
        self.contentView.addSubview(self.picker)
        EasyToolbarPickerKeyboardConfig.picker.apply(for: self.picker)
    }
}

#if EASY_DATA

open class EasyToolbarPickerKeyboard<DataProviderType: EasyDataListProviderType>: EasyToolbarPickerKeyboardBase<[DataProviderType.ModelType]> {
    ///数据源
    public let dataSource = EasyPickerViewDataSource<DataProviderType>()
    
    public init(provider: DataProviderType) {
        super.init(frame: .zero)
        self.dataSource.dataProvider = provider
        self.dataSource.pickerView = self.picker
        self.dataSource.reloadData()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func currentValue() -> [DataProviderType.ModelType]? {
        return self.dataSource.selectedModels
    }
}

open class EasyToolbarPickerKeyboard2<FirstType: EasyDataListProviderType, SecondType: EasyDataListProviderType>: EasyToolbarPickerKeyboardBase<(FirstType.ModelType, SecondType.ModelType)> {
    ///数据源
    public let dataSource = EasyPickerViewDataSource2<FirstType, SecondType>()
    
    public init(providers first: FirstType,_ second: SecondType) {
        super.init(frame: .zero)
        self.dataSource.firstDataProvider = first
        self.dataSource.secondDataProvider = second
        self.dataSource.pickerView = self.picker
        self.dataSource.reloadData()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func currentValue() -> (FirstType.ModelType, SecondType.ModelType)? {
        if let value = self.dataSource.selectedModels, value.count >= 2 {
            return (value[0] as! FirstType.ModelType, value[1] as! SecondType.ModelType)
        }
        return nil
    }
}

open class EasyToolbarPickerKeyboard3<FirstType: EasyDataListProviderType, SecondType: EasyDataListProviderType, ThirdType: EasyDataListProviderType>: EasyToolbarPickerKeyboardBase<(FirstType.ModelType, SecondType.ModelType, ThirdType.ModelType)> {
    ///数据源
    public let dataSource = EasyPickerViewDataSource3<FirstType, SecondType, ThirdType>()
    
    public init(providers first: FirstType, _ second: SecondType, _ third: ThirdType) {
        super.init(frame: .zero)
        self.dataSource.firstDataProvider = first
        self.dataSource.secondDataProvider = second
        self.dataSource.thirdDataProvider = third
        self.dataSource.pickerView = self.picker
        self.dataSource.reloadData()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func currentValue() -> (FirstType.ModelType, SecondType.ModelType, ThirdType.ModelType)? {
        if let value = self.dataSource.selectedModels, value.count >= 3 {
            return (value[0] as! FirstType.ModelType, value[1] as! SecondType.ModelType, value[2] as! ThirdType.ModelType)
        }
        return nil
    }
}

open class EasyToolbarPickerKeyboard4<FirstType: EasyDataListProviderType, SecondType: EasyDataListProviderType, ThirdType: EasyDataListProviderType, FourthType: EasyDataListProviderType>: EasyToolbarPickerKeyboardBase<(FirstType.ModelType, SecondType.ModelType, ThirdType.ModelType, FourthType.ModelType)> {
    ///数据源
    public let dataSource = EasyPickerViewDataSource4<FirstType, SecondType, ThirdType, FourthType>()
    
    public init(providers first: FirstType, _ second: SecondType, _ third: ThirdType, _ fourth: FourthType) {
        super.init(frame: .zero)
        self.dataSource.firstDataProvider = first
        self.dataSource.secondDataProvider = second
        self.dataSource.thirdDataProvider = third
        self.dataSource.fourthDataProvider = fourth
        self.dataSource.pickerView = self.picker
        self.dataSource.reloadData()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func currentValue() -> (FirstType.ModelType, SecondType.ModelType, ThirdType.ModelType, FourthType.ModelType)? {
        if let value = self.dataSource.selectedModels, value.count >= 4 {
            return (value[0] as! FirstType.ModelType, value[1] as! SecondType.ModelType, value[2] as! ThirdType.ModelType, value[3] as! FourthType.ModelType)
        }
        return nil
    }
}

#endif
