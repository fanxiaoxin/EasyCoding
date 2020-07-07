//
//  ECToolbarPickerKeyboard.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/7.
//

import UIKit

///选择器配置
public struct ECToolbarPickerKeyboardConfig {
    ///选择器
    public static let picker = ECControlConfig<UIPickerView>(styles: [], layouts: [.margin])
}
//扩展ECToolbarKeyboardConfig，简化使用复杂度，统一在ECToolbarKeyboardConfig里配置
extension ECToolbarKeyboardConfig {
    public var picker: ECControlConfig<UIPickerView> {
        return ECToolbarPickerKeyboardConfig.picker
    }
}

open class ECToolbarPickerKeyboardBase<InputType>: ECToolbarKeyboard<InputType> {
    open var picker = UIPickerView()
    open override func load() {
        super.load()
        
        self.contentView.addSubview(self.picker)
        ECToolbarPickerKeyboardConfig.picker.apply(for: self.picker)
    }
}

open class ECToolbarPickerKeyboard<DataProviderType: ECDataListProviderType>: ECToolbarPickerKeyboardBase<[DataProviderType.ModelType]> {
    ///数据源
    public let dataSource = ECPickerViewDataSource<DataProviderType>()
    
    public init(provider: DataProviderType) {
        super.init(frame: .zero)
        self.dataSource.dataProvider = provider
        self.dataSource.pickerView = self.picker
        self.dataSource.reloadData()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func currentValue() -> [DataProviderType.ModelType] {
        return self.dataSource.selectedModels!
    }
}

open class ECToolbarPickerKeyboard2<FirstType: ECDataListProviderType, SecondType: ECDataListProviderType>: ECToolbarPickerKeyboardBase<(FirstType.ModelType, SecondType.ModelType)> {
    ///数据源
    public let dataSource = ECPickerViewDataSource2<FirstType, SecondType>()
    
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
    
    open override func currentValue() -> (FirstType.ModelType, SecondType.ModelType) {
        let value = self.dataSource.selectedModels!
        return (value[0] as! FirstType.ModelType, value[1] as! SecondType.ModelType)
    }
}

open class ECToolbarPickerKeyboard3<FirstType: ECDataListProviderType, SecondType: ECDataListProviderType, ThirdType: ECDataListProviderType>: ECToolbarPickerKeyboardBase<(FirstType.ModelType, SecondType.ModelType, ThirdType.ModelType)> {
    ///数据源
    public let dataSource = ECPickerViewDataSource3<FirstType, SecondType, ThirdType>()
    
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
    
    open override func currentValue() -> (FirstType.ModelType, SecondType.ModelType, ThirdType.ModelType) {
        let value = self.dataSource.selectedModels!
        return (value[0] as! FirstType.ModelType, value[1] as! SecondType.ModelType, value[2] as! ThirdType.ModelType)
    }
}

open class ECToolbarPickerKeyboard4<FirstType: ECDataListProviderType, SecondType: ECDataListProviderType, ThirdType: ECDataListProviderType, FourthType: ECDataListProviderType>: ECToolbarPickerKeyboardBase<(FirstType.ModelType, SecondType.ModelType, ThirdType.ModelType, FourthType.ModelType)> {
    ///数据源
    public let dataSource = ECPickerViewDataSource4<FirstType, SecondType, ThirdType, FourthType>()
    
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
    
    open override func currentValue() -> (FirstType.ModelType, SecondType.ModelType, ThirdType.ModelType, FourthType.ModelType) {
        let value = self.dataSource.selectedModels!
        return (value[0] as! FirstType.ModelType, value[1] as! SecondType.ModelType, value[2] as! ThirdType.ModelType, value[3] as! FourthType.ModelType)
    }
}
