//
//  ECPickerTextConstraint.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/8.
//

import UIKit

public class ECPickerTextConstraintBase<InputType, KeyboardType: ECToolbarPickerKeyboardBase<InputType>>: ECKeyboardTextConstraint<KeyboardType>{
    public override init(_ keyboard: KeyboardType) {
        super.init(keyboard)
        self.keyboard.actionForClose = { [weak self] in
            self?.textField?.resignFirstResponder()
        }
    }
    
    override open var textField: UITextField? {
        willSet{
            textField?.tintColor = UITextField.appearance().tintColor//显示光标
        }
        didSet {
            textField?.tintColor = UIColor.clear//将光标置为透明
        }
    }
    
}

public class ECPickerTextConstraint<DataProviderType: ECDataListProviderType>: ECPickerTextConstraintBase<[DataProviderType.ModelType], ECToolbarPickerKeyboard<DataProviderType>>{
    public init(dataProvider: DataProviderType) {
        super.init(ECToolbarPickerKeyboard<DataProviderType>(provider: dataProvider))
        
        self.textForValue = { value in
            if let v = value as? [ECTextualizable] {
                if v.count == 1 {
                    return v[0].text
                }else {
                    return v.map({ $0.text }).joined(separator: ", ")
                }
            }else if let v = value as? [CustomStringConvertible] {
                if v.count == 1 {
                    return v[0].description
                }else {
                    return v.map({ $0.description }).joined(separator: ", ")
                }
            }
            return value.map({ "\($0)" }).joined(separator: ", ")
        }
    }
}
public class ECPickerTextConstraint2<FirstType: ECDataListProviderType, SecondType: ECDataListProviderType>: ECPickerTextConstraintBase<(FirstType.ModelType, SecondType.ModelType), ECToolbarPickerKeyboard2<FirstType, SecondType>>{
    public init(providers first: FirstType, _ second: SecondType) {
        super.init(ECToolbarPickerKeyboard2<FirstType, SecondType>(providers: first, second))
    }
}
public class ECPickerTextConstraint3<FirstType: ECDataListProviderType, SecondType: ECDataListProviderType, ThirdType: ECDataListProviderType>: ECPickerTextConstraintBase<(FirstType.ModelType, SecondType.ModelType, ThirdType.ModelType), ECToolbarPickerKeyboard3<FirstType, SecondType, ThirdType>>{
    public init(providers first: FirstType, _ second: SecondType, _ third: ThirdType) {
        super.init(ECToolbarPickerKeyboard3<FirstType, SecondType, ThirdType>(providers: first, second, third))
    }
}
public class ECPickerTextConstraint4<FirstType: ECDataListProviderType, SecondType: ECDataListProviderType, ThirdType: ECDataListProviderType, FourthType: ECDataListProviderType>: ECPickerTextConstraintBase<(FirstType.ModelType, SecondType.ModelType, ThirdType.ModelType, FourthType.ModelType), ECToolbarPickerKeyboard4<FirstType, SecondType, ThirdType, FourthType>>{
    public init(providers first: FirstType, _ second: SecondType, _ third: ThirdType,  _ fourth: FourthType) {
        super.init(ECToolbarPickerKeyboard4<FirstType, SecondType, ThirdType, FourthType>(providers: first, second, third, fourth))
    }
}


extension ECTextConstraint {
    public static func picker<DataProviderType: ECDataListProviderType>(provider: DataProviderType) -> ECPickerTextConstraint<DataProviderType>{
        return ECPickerTextConstraint<DataProviderType>(dataProvider: provider)
    }
    public static func picker<FirstType: ECDataListProviderType, SecondType: ECDataListProviderType>(providers first: FirstType, _ second: SecondType, text: @escaping ((FirstType.ModelType, SecondType.ModelType)) -> String) -> ECPickerTextConstraint2<FirstType, SecondType>{
        let picker = ECPickerTextConstraint2<FirstType, SecondType>(providers: first, second)
        picker.textForValue = text
        return picker
    }
    public static func picker<FirstType: ECDataListProviderType, SecondType: ECDataListProviderType, ThirdType: ECDataListProviderType>(providers first: FirstType, _ second: SecondType, _ third: ThirdType, text: @escaping ((FirstType.ModelType, SecondType.ModelType,ThirdType.ModelType)) -> String) -> ECPickerTextConstraint3<FirstType, SecondType, ThirdType>{
        let picker = ECPickerTextConstraint3<FirstType, SecondType, ThirdType>(providers: first, second, third)
        picker.textForValue = text
        return picker
    }
    public static func picker<FirstType: ECDataListProviderType, SecondType: ECDataListProviderType, ThirdType: ECDataListProviderType, FourthType: ECDataListProviderType>(providers first: FirstType, _ second: SecondType, _ third: ThirdType,  _ fourth: FourthType, text: @escaping ((FirstType.ModelType, SecondType.ModelType,ThirdType.ModelType, FourthType.ModelType)) -> String) -> ECPickerTextConstraint4<FirstType, SecondType, ThirdType, FourthType>{
        let picker = ECPickerTextConstraint4<FirstType, SecondType, ThirdType, FourthType>(providers: first, second, third, fourth)
        picker.textForValue = text
        return picker
    }
}
