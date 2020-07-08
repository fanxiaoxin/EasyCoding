//
//  Picker.swift
//  ECKit
//
//  Created by Fanxx on 2018/4/17.
//  Copyright © 2018年 fanxx. All rights reserved.
//

import UIKit

public struct ECPicker {
    ///显示自定义视图
    @discardableResult
    public static func create<ViewType: UIView>(_ title:String?,customView:ViewType, completion: @escaping (ViewType)->Void) -> ECToolbarCustomKeyboard<ViewType, Void> {
        let keyboard = ECToolbarCustomKeyboard<ViewType, Void>(customView: customView, value: completion)
        keyboard.toolbar.titleLabel.text = title
        keyboard.isHiddenForTouchBackground = true
        return keyboard
    }
    ///显示日期选择器
    @discardableResult
    public static func create(_ title:String?, date:Date? = nil, mode: UIDatePicker.Mode, min: Date? = nil, max: Date? = nil,completion: @escaping (Date)->Void) -> ECToolbarDatePickerKeyboard {
        let keyboard = ECToolbarDatePickerKeyboard()
        keyboard.toolbar.titleLabel.text = title
        keyboard.isHiddenForTouchBackground = true
        if let d = date {
            keyboard.picker.date = d
        }
        if let m = min {
            keyboard.picker.minimumDate = m
        }
        if let mx = max {
            keyboard.picker.maximumDate = mx
        }
        keyboard.inputReceive = completion
        return keyboard
    }
    ///显示列表选择器
    @discardableResult
    public static func create<DataProviderType: ECDataListProviderType>(_ title:String?, dataProvider: DataProviderType, completion: @escaping ([DataProviderType.ModelType])->Void) -> ECToolbarPickerKeyboard<DataProviderType> {
        let keyboard = ECToolbarPickerKeyboard<DataProviderType>(provider: dataProvider)
        keyboard.toolbar.titleLabel.text = title
        keyboard.isHiddenForTouchBackground = true
        keyboard.inputReceive = completion
        return keyboard
    }
    ///显示列表选择器
    @discardableResult
    public static func create<FirstType: ECDataListProviderType, SecondType: ECDataListProviderType>(_ title:String?, col1 first: FirstType, col2 second: SecondType, completion: @escaping ((FirstType.ModelType, SecondType.ModelType))->Void) -> ECToolbarPickerKeyboard2<FirstType, SecondType> {
        let keyboard = ECToolbarPickerKeyboard2<FirstType, SecondType>(providers: first, second)
        keyboard.toolbar.titleLabel.text = title
        keyboard.isHiddenForTouchBackground = true
        keyboard.inputReceive = completion
        return keyboard
    }
    ///显示列表选择器
    @discardableResult
    public static func create<FirstType: ECDataListProviderType, SecondType: ECDataListProviderType, ThirdType: ECDataListProviderType>(_ title:String?, col1 first: FirstType, col2 second: SecondType, col3 third: ThirdType, completion: @escaping ((FirstType.ModelType, SecondType.ModelType, ThirdType.ModelType))->Void) -> ECToolbarPickerKeyboard3<FirstType, SecondType, ThirdType> {
        let keyboard = ECToolbarPickerKeyboard3<FirstType, SecondType, ThirdType>(providers: first, second, third)
        keyboard.toolbar.titleLabel.text = title
        keyboard.isHiddenForTouchBackground = true
        keyboard.inputReceive = completion
        return keyboard
    }
    ///显示列表选择器
    @discardableResult
    public static func create<FirstType: ECDataListProviderType, SecondType: ECDataListProviderType, ThirdType: ECDataListProviderType, FourthType: ECDataListProviderType>(_ title:String?, col1 first: FirstType, col2 second: SecondType, col3 third: ThirdType, col3 fourth: FourthType, completion: @escaping ((FirstType.ModelType, SecondType.ModelType, ThirdType.ModelType, FourthType.ModelType))->Void) -> ECToolbarPickerKeyboard4<FirstType, SecondType, ThirdType, FourthType> {
        let keyboard = ECToolbarPickerKeyboard4<FirstType, SecondType, ThirdType, FourthType>(providers: first, second, third, fourth)
        keyboard.toolbar.titleLabel.text = title
        keyboard.isHiddenForTouchBackground = true
        keyboard.inputReceive = completion
        return keyboard
    }
}
