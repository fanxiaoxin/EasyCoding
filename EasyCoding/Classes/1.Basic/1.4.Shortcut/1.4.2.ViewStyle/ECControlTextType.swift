//
//  ControlTextSetable.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/22.
//

import UIKit

///可设置控件的文本类型
public protocol ECControlTextType {
    func setText(to label: UILabel)
    func setText(to button: UIButton, for state: UIControl.State)
    func setText(to textField: UITextField)
    func setText(to textView: UITextView)
}
extension String: ECControlTextType {
    public func setText(to label: UILabel) {
        label.text = self
    }
    public func setText(to button: UIButton, for state: UIControl.State) {
        button.setTitle(self, for: state)
    }
    public func setText(to textField: UITextField) {
        textField.text = self
    }
    public func setText(to textView: UITextView) {
        textView.text = self
    }
}
extension NSAttributedString: ECControlTextType {
    public func setText(to label: UILabel) {
        label.attributedText = self
    }
    public func setText(to button: UIButton, for state: UIControl.State) {
        button.setAttributedTitle(self, for: state)
    }
    public func setText(to textField: UITextField) {
        textField.attributedText = self
    }
    public func setText(to textView: UITextView) {
        textView.attributedText = self
    }
}
extension ECAttributedString: ECControlTextType {
    public func setText(to label: UILabel) {
        label.attributedText = self.attributedString
    }
    public func setText(to button: UIButton, for state: UIControl.State) {
        button.setAttributedTitle(self.attributedString, for: state)
    }
    public func setText(to textField: UITextField) {
        textField.attributedText = self.attributedString
    }
    public func setText(to textView: UITextView) {
        textView.attributedText = self.attributedString
    }
}

