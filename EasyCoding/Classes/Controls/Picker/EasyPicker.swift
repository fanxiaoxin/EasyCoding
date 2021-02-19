//
//  Picker.swift
//  EasyKit
//
//  Created by Fanxx on 2018/4/17.
//  Copyright © 2018年 fanxx. All rights reserved.
//

import UIKit

public struct EasyPicker {
    ///显示自定义视图
    @discardableResult
    public static func create<ViewType: UIView>(_ title:String?,customView:ViewType, completion: @escaping (ViewType)->Void) -> EasyToolbarCustomKeyboard<ViewType, Void> {
        let keyboard = EasyToolbarCustomKeyboard<ViewType, Void>(customView: customView, value: completion)
        keyboard.toolbar.titleLabel.text = title
        keyboard.isHiddenForTouchBackground = true
        return keyboard
    }
    ///显示日期选择器
    @discardableResult
    public static func create(_ title:String?, date:Date? = nil, mode: UIDatePicker.Mode, min: Date? = nil, max: Date? = nil,completion: @escaping (Date)->Void) -> EasyToolbarDatePickerKeyboard {
        let keyboard = EasyToolbarDatePickerKeyboard()
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
    
    #if EASY_DATA
    
    ///显示列表选择器
    @discardableResult
    public static func create<DataProviderType: EasyDataListProviderType>(_ title:String?, dataProvider: DataProviderType, completion: @escaping ([DataProviderType.ModelType])->Void) -> EasyToolbarPickerKeyboard<DataProviderType> {
        let keyboard = EasyToolbarPickerKeyboard<DataProviderType>(provider: dataProvider)
        keyboard.toolbar.titleLabel.text = title
        keyboard.isHiddenForTouchBackground = true
        keyboard.inputReceive = completion
        return keyboard
    }
    ///显示列表选择器
    @discardableResult
    public static func create<FirstType: EasyDataListProviderType, SecondType: EasyDataListProviderType>(_ title:String?, col1 first: FirstType, col2 second: SecondType, completion: @escaping ((FirstType.ModelType, SecondType.ModelType))->Void) -> EasyToolbarPickerKeyboard2<FirstType, SecondType> {
        let keyboard = EasyToolbarPickerKeyboard2<FirstType, SecondType>(providers: first, second)
        keyboard.toolbar.titleLabel.text = title
        keyboard.isHiddenForTouchBackground = true
        keyboard.inputReceive = completion
        return keyboard
    }
    ///显示列表选择器
    @discardableResult
    public static func create<FirstType: EasyDataListProviderType, SecondType: EasyDataListProviderType, ThirdType: EasyDataListProviderType>(_ title:String?, col1 first: FirstType, col2 second: SecondType, col3 third: ThirdType, completion: @escaping ((FirstType.ModelType, SecondType.ModelType, ThirdType.ModelType))->Void) -> EasyToolbarPickerKeyboard3<FirstType, SecondType, ThirdType> {
        let keyboard = EasyToolbarPickerKeyboard3<FirstType, SecondType, ThirdType>(providers: first, second, third)
        keyboard.toolbar.titleLabel.text = title
        keyboard.isHiddenForTouchBackground = true
        keyboard.inputReceive = completion
        return keyboard
    }
    ///显示列表选择器
    @discardableResult
    public static func create<FirstType: EasyDataListProviderType, SecondType: EasyDataListProviderType, ThirdType: EasyDataListProviderType, FourthType: EasyDataListProviderType>(_ title:String?, col1 first: FirstType, col2 second: SecondType, col3 third: ThirdType, col3 fourth: FourthType, completion: @escaping ((FirstType.ModelType, SecondType.ModelType, ThirdType.ModelType, FourthType.ModelType))->Void) -> EasyToolbarPickerKeyboard4<FirstType, SecondType, ThirdType, FourthType> {
        let keyboard = EasyToolbarPickerKeyboard4<FirstType, SecondType, ThirdType, FourthType>(providers: first, second, third, fourth)
        keyboard.toolbar.titleLabel.text = title
        keyboard.isHiddenForTouchBackground = true
        keyboard.inputReceive = completion
        return keyboard
    }
    
    #endif
}
