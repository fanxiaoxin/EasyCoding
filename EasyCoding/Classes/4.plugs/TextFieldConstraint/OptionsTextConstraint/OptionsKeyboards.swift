//
//  OptionsKeyboards.swift
//  ECKit
//
//  Created by Fanxx on 2019/8/28.
//

import UIKit

///带选项的视图
open class ECPickerKeyboard<ValueType: ECOptionValueType>: UIView, ECOptionsKeyboardType, UIPickerViewDataSource, UIPickerViewDelegate {
    
    open var options: [ValueType] {
        didSet {
            self.picker.reloadComponent(0)
        }
    }
    
    public let titleLabel = UILabel()
    public let submitButton = UIButton()
    public let cancelButton = UIButton()
    public let bar = UIView()
    public let picker: UIPickerView = UIPickerView()
    public init(_ title: String? = nil, options: [ValueType]) {
        self.titleLabel.text = title
        self.options = options
        super.init(frame: .init(x: 0, y: 0, width: 320, height: 260))
        self.load()
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    open func load() {
        self.easy.add(bar, layout: .top, .marginX)
            .next(picker, layout: .bottomTop).height(216)
            .parent(.marginX, .bottom)
        
        bar.easy.style(.bg(.white))
        .append(titleLabel, layout: .center)
            .append(submitButton.easy(.text("确定"), .event(self, #selector(self.submit))), layout: .right(15), .centerY).height(44)
            .append(cancelButton.easy(.text("取消"), .event(self, #selector(self.cancel))), layout: .left(15), .centerY).height(44)
        picker.easy.style(.bg(.white))
        
        picker.dataSource = self
        picker.delegate = self
        
        bar.backgroundColor = UIColor.easy.rgb(0xfefefe)
        titleLabel.textColor = UIColor.easy.rgb(0x666666)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        submitButton.setTitleColor(UIColor.easy.rgb(0x333333), for: .normal)
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
    }
    open func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    open func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.options.count
    }
    
    open func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.options[row].optionValueTitle
    }
    open func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    @objc open func submit() {
        self.selectedValue = self.options[self.picker.selectedRow(inComponent: 0)]
    }
    @objc open func cancel() {
        NotificationCenter.default.post(name: Self.selectedValueChangedKey , object: self)
    }
    open func load(value: ValueType?) {
        if let v = value {
            if let idx = self.options.firstIndex(of: v) {
                self.picker.selectRow(idx, inComponent: 0, animated: false)
            }
        }
    }
}
extension EC.NamespaceImplement where Base: UITextField {
    public func option<T:ECOptionValueType>() -> T? {
        if let tc = self.textConstraint as? ECOptionsTextConstraint<ECPickerKeyboard<T>> {
            return tc.value
        }
        return nil
    }
    public func option<T:ECOptionValueType>(_ value: T) {
        if let tc = self.textConstraint as? ECOptionsTextConstraint<ECPickerKeyboard<T>> {
            tc.value = value
        }else{
            self.base.text = value.optionValueTitle
        }
    }
}


extension ECTextConstraint {
    public static func options<ValueType: ECOptionValueType>(_ options: [ValueType], title: String? = nil) -> ECTextConstraint {
        let kb = ECPickerKeyboard<ValueType>(title, options: options)
        let c = ECOptionsTextConstraint<ECPickerKeyboard<ValueType>>(kb)
        return c
    }
}
