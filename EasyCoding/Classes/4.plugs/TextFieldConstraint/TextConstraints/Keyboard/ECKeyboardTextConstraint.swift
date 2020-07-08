//
//  ECKeyboardTextConstraint.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/8.
//

import UIKit

open class ECKeyboardTextConstraint<KeyboardType: ECKeyboardType>: ECTextConstraint {
    public let keyboard: KeyboardType
    public lazy var textForValue: (KeyboardType.InputType) -> String = {
        return { value in
            if let v = value as? ECTextualizable {
                return v.text
            }else if let v = value as? CustomStringConvertible {
                return v.description
            }
            return "\(value)"
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

extension ECTextConstraint {
    public static func keyboard<KeyboardType: ECKeyboardType>(_ keyboard: KeyboardType) -> ECKeyboardTextConstraint<KeyboardType>{
        return ECKeyboardTextConstraint<KeyboardType>(keyboard)
    }
}
