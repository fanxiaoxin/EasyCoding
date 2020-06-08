//
//  OptionsKeyboardType.swift
//  ECKit
//
//  Created by Fanxx on 2019/8/28.
//

import UIKit

///选项值类型
public protocol ECOptionValueType: Equatable {
    ///选项名
    var optionValueTitle: String? { get }
}
extension ECOptionValueType where Self: CustomStringConvertible{
    ///选项名
    public var optionValueTitle: String? {
        return self.description
    }
}
extension String: ECOptionValueType { }
///带栏高260, 不带栏高216
public protocol ECOptionsKeyboardType: UIView {
    associatedtype ValueType: ECOptionValueType
    func load(value: ValueType?)
}
extension ECOptionsKeyboardType {
    ///选中值
    public var selectedValue: ValueType? {
        get {
            return self.easy.getAssociated(object: "SelectedValue")
        }
        set {
            self.easy.setAssociated(object: newValue, key: "SelectedValue")
            self.load(value: newValue)
            NotificationCenter.default.post(name: Self.selectedValueChangedKey , object: self)
        }
    }
    public static var selectedValueChangedKey: NSNotification.Name {
        return NSNotification.Name("ECOptionsViewSelectedValueChangedKey")
    }
}
