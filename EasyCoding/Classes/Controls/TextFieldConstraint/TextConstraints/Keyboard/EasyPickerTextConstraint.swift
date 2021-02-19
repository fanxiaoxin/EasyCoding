//
//  EasyPickerTextConstraint.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/8.
//

import UIKit

public class EasyPickerTextConstraintBase<InputType, KeyboardType: EasyToolbarPickerKeyboardBase<InputType>>: EasyKeyboardTextConstraint<KeyboardType>{
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

#if EASY_DATA

public class EasyPickerTextConstraint<DataProviderType: EasyDataListProviderType>: EasyPickerTextConstraintBase<[DataProviderType.ModelType], EasyToolbarPickerKeyboard<DataProviderType>>{
    public init(dataProvider: DataProviderType) {
        super.init(EasyToolbarPickerKeyboard<DataProviderType>(provider: dataProvider))
        
        self.textForValue = { value in
            if let v = value as? [EasyTextualizable] {
                if v.count == 1 {
                    return v[0].friendlyText
                }else {
                    return v.map({ $0.friendlyText }).joined(separator: ", ")
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
public class EasyPickerTextConstraint2<FirstType: EasyDataListProviderType, SecondType: EasyDataListProviderType>: EasyPickerTextConstraintBase<(FirstType.ModelType, SecondType.ModelType), EasyToolbarPickerKeyboard2<FirstType, SecondType>>{
    public init(providers first: FirstType, _ second: SecondType) {
        super.init(EasyToolbarPickerKeyboard2<FirstType, SecondType>(providers: first, second))
    }
}
public class EasyPickerTextConstraint3<FirstType: EasyDataListProviderType, SecondType: EasyDataListProviderType, ThirdType: EasyDataListProviderType>: EasyPickerTextConstraintBase<(FirstType.ModelType, SecondType.ModelType, ThirdType.ModelType), EasyToolbarPickerKeyboard3<FirstType, SecondType, ThirdType>>{
    public init(providers first: FirstType, _ second: SecondType, _ third: ThirdType) {
        super.init(EasyToolbarPickerKeyboard3<FirstType, SecondType, ThirdType>(providers: first, second, third))
    }
}
public class EasyPickerTextConstraint4<FirstType: EasyDataListProviderType, SecondType: EasyDataListProviderType, ThirdType: EasyDataListProviderType, FourthType: EasyDataListProviderType>: EasyPickerTextConstraintBase<(FirstType.ModelType, SecondType.ModelType, ThirdType.ModelType, FourthType.ModelType), EasyToolbarPickerKeyboard4<FirstType, SecondType, ThirdType, FourthType>>{
    public init(providers first: FirstType, _ second: SecondType, _ third: ThirdType,  _ fourth: FourthType) {
        super.init(EasyToolbarPickerKeyboard4<FirstType, SecondType, ThirdType, FourthType>(providers: first, second, third, fourth))
    }
}


extension EasyTextConstraint {
    public static func picker<DataProviderType: EasyDataListProviderType>(provider: DataProviderType) -> EasyPickerTextConstraint<DataProviderType>{
        return EasyPickerTextConstraint<DataProviderType>(dataProvider: provider)
    }
    public static func picker<FirstType: EasyDataListProviderType, SecondType: EasyDataListProviderType>(providers first: FirstType, _ second: SecondType, text: @escaping ((FirstType.ModelType, SecondType.ModelType)) -> String) -> EasyPickerTextConstraint2<FirstType, SecondType>{
        let picker = EasyPickerTextConstraint2<FirstType, SecondType>(providers: first, second)
        picker.textForValue = text
        return picker
    }
    public static func picker<FirstType: EasyDataListProviderType, SecondType: EasyDataListProviderType, ThirdType: EasyDataListProviderType>(providers first: FirstType, _ second: SecondType, _ third: ThirdType, text: @escaping ((FirstType.ModelType, SecondType.ModelType,ThirdType.ModelType)) -> String) -> EasyPickerTextConstraint3<FirstType, SecondType, ThirdType>{
        let picker = EasyPickerTextConstraint3<FirstType, SecondType, ThirdType>(providers: first, second, third)
        picker.textForValue = text
        return picker
    }
    public static func picker<FirstType: EasyDataListProviderType, SecondType: EasyDataListProviderType, ThirdType: EasyDataListProviderType, FourthType: EasyDataListProviderType>(providers first: FirstType, _ second: SecondType, _ third: ThirdType,  _ fourth: FourthType, text: @escaping ((FirstType.ModelType, SecondType.ModelType,ThirdType.ModelType, FourthType.ModelType)) -> String) -> EasyPickerTextConstraint4<FirstType, SecondType, ThirdType, FourthType>{
        let picker = EasyPickerTextConstraint4<FirstType, SecondType, ThirdType, FourthType>(providers: first, second, third, fourth)
        picker.textForValue = text
        return picker
    }
}

#endif
