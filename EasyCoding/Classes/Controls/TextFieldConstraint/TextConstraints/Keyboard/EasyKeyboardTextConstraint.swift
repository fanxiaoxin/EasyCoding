//
//  EasyKeyboardTextConstraint.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/8.
//

import UIKit

open class EasyKeyboardTextConstraint<KeyboardType: EasyKeyboardType>: EasyTextConstraint {
    public let keyboard: KeyboardType
    public lazy var textForValue: (KeyboardType.InputType) -> String = {
        return { value in
            return EasyText(value)
        }
    }()
    ///观察者，用于观察OptionsView的改变
//    private var optionsObservation: NSKeyValueObservation?
    public init(_ keyboard: KeyboardType) {
        self.keyboard = keyboard
        keyboard.frame = keyboard.defaultFrame
        super.init()
        keyboard.inputReceive = { [weak self] value in
            if let s = self {
                s.setText(s.textForValue(value))
                s.textField?.resignFirstResponder()
            }
        }
    }
    
    override open var textField: UITextField? {
        willSet{
            textField?.inputView = nil
        }
        didSet {
            textField?.inputView = self.keyboard
        }
    }
    func setText(_ text: String) {
        self.textField?.text = text
        self.textField?.sendActions(for: .valueChanged)
    }
    override open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}

extension EasyTextConstraint {
    public static func keyboard<KeyboardType: EasyKeyboardType>(_ keyboard: KeyboardType) -> EasyKeyboardTextConstraint<KeyboardType>{
        return EasyKeyboardTextConstraint<KeyboardType>(keyboard)
    }
}
