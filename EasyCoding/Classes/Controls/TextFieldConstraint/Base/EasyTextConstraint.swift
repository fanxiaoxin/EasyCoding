//
//  TextFieldConstraint.swift
//  EasyKit
//
//  Created by Fanxx on 2018/3/27.
//  Copyright © 2018年 fanxx. All rights reserved.
//

import UIKit

open class EasyTextConstraint: NSObject,UITextFieldDelegate {
    public var otherConstraint: EasyTextConstraint?
    open weak var textField: UITextField? {
        didSet{
            self.otherConstraint?.textField = self.textField
        }
    }
    weak var textFieldDelegate: UITextFieldDelegate?
    ///切换delegate的设置到自定义属性
    static var swizzleTextFieldDelegateMethod: Int = {
        UITextField.easy.swizzle(#selector(getter: UITextField.delegate), to: #selector(getter: UITextField.__ec_text_delegate))
        UITextField.easy.swizzle(#selector(setter: UITextField.delegate), to: #selector(setter: UITextField.__ec_text_delegate))
        return 0
    }()
    public convenience init(other constraint:EasyTextConstraint) {
        self.init()
        self.otherConstraint = constraint
    }
    
    open func textFieldDidBeginEditing(_ textField: UITextField) {
        self.otherConstraint?.textFieldDidBeginEditing(textField)
        self.textFieldDelegate?.textFieldDidBeginEditing?(textField)
    }
    open func textFieldDidEndEditing(_ textField: UITextField) {
        self.otherConstraint?.textFieldDidEndEditing(textField)
        self.textFieldDelegate?.textFieldDidEndEditing?(textField)
    }
    open func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return (self.otherConstraint?.textFieldShouldClear(textField) ?? true) &&
                (self.textFieldDelegate?.textFieldShouldClear?(textField) ?? true)
    }
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return (self.otherConstraint?.textFieldShouldReturn(textField) ?? true) &&
            (self.textFieldDelegate?.textFieldShouldReturn?(textField) ?? true)
    }
    open func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return (self.otherConstraint?.textFieldShouldEndEditing(textField) ?? true) &&
            (self.textFieldDelegate?.textFieldShouldEndEditing?(textField) ?? true)
    }
    open func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return (self.otherConstraint?.textFieldShouldBeginEditing(textField) ?? true) &&
            (self.textFieldDelegate?.textFieldShouldBeginEditing?(textField) ?? true)
    }
    @available(iOS 10.0, *)
    open func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        self.otherConstraint?.textFieldDidEndEditing(textField, reason: reason) ??
        self.otherConstraint?.textFieldDidEndEditing(textField)
        
        self.textFieldDelegate?.textFieldDidEndEditing?(textField, reason: reason) ??
        self.textFieldDelegate?.textFieldDidEndEditing?(textField)
    }
    open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return (self.otherConstraint?.textField(textField, shouldChangeCharactersIn: range, replacementString: string) ?? true) &&
            (self.textFieldDelegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) ?? true)
    }
}
private var fx_key_textfield_textconstraiint: Void?
extension EasyCoding where Base: UITextField {
    public var textConstraint : EasyTextConstraint? {
        return objc_getAssociatedObject(self.base, &fx_key_textfield_textconstraiint) as? EasyTextConstraint
    }
    public func set(textConstraint: EasyTextConstraint?) {
        ///调用静态属性执行Swizzle，因为静态属性只执行1次
        let _ = EasyTextConstraint.swizzleTextFieldDelegateMethod
        
        self.textConstraint?.textField = nil
        let oldDelegate = self.base.delegate
        objc_setAssociatedObject(self.base, &fx_key_textfield_textconstraiint, textConstraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        textConstraint?.textFieldDelegate = oldDelegate
        if let c = textConstraint {
            self.base.__ec_text_delegate = c
        }else{
            self.base.__ec_text_delegate = textConstraint
        }
        textConstraint?.textField = self.base
    }
}
extension UITextField {
    @objc var __ec_text_delegate:  UITextFieldDelegate? {
        get{
            if let c = self.easy.textConstraint {
                return c.textFieldDelegate
            }else{
                return self.__ec_text_delegate
            }
        }
        set{
            if let c = self.easy.textConstraint {
                c.textFieldDelegate = newValue
            }else{
                self.__ec_text_delegate = newValue
            }
        }
    }

}

extension EasyStyleSetting where TargetType: UITextField {
    public static func constraint(_ constraint:EasyTextConstraint) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.easy.set(textConstraint:constraint)
        })
    }
    public static func constraints(_ constraints:EasyTextConstraint...) -> EasyStyleSetting<TargetType> {
        assert(constraints.count > 0)
        let constraint = constraints[0]
        //将多个约束合并到一个
        if constraints.count > 1 {
            var next = constraint
            for i in 1..<constraints.count {
                next.otherConstraint = constraints[i]
                next = constraints[i]
            }
        }
        return .init(action: { (target) in
            target.easy.set(textConstraint:constraint)
        })
    }
}
