//
//  TextField.swift
//  EasyKit
//
//  Created by Fanxx on 2019/7/24.
//

import UIKit

open class EasyTextField: UITextField {
    ///内边距
    open var padding: UIEdgeInsets = UIEdgeInsets.zero {
        didSet {
            self.placeholderLabel.snp.updateConstraints { (make) in
                make.top.equalToSuperview().offset(self.padding.top)
                make.bottom.equalToSuperview().offset(-self.padding.bottom)
                make.left.equalToSuperview().offset(self.padding.left)
                make.right.equalToSuperview().offset(-self.padding.right)
            }
        }
    }
    
    public let placeholderLabel = UILabel()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.load()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.load()
    }
    open func load() {
        placeholderLabel.text = text
        placeholderLabel.numberOfLines = 0;
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.textAlignment = self.textAlignment
        placeholderLabel.sizeToFit()
        
        self.addSubview(placeholderLabel)
        
        placeholderLabel.font = self.font
        
        placeholderLabel.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalToSuperview()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(EasyTextField.textFieldDidChange), name: UITextField.textDidChangeNotification, object: self)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    open override var font: UIFont? {
        didSet {
            self.placeholderLabel.font = self.font
        }
    }
    open override var placeholder: String? {
        get {
            return self.placeholderLabel.text
        }
        set {
            self.placeholderLabel.text = newValue
        }
    }
    open override var attributedPlaceholder: NSAttributedString?{
        get {
            return self.placeholderLabel.attributedText
        }
        set {
            self.placeholderLabel.attributedText = newValue
        }
    }
    open override var text: String? {
        didSet {
            self.textFieldDidChange(hidePlaceHolder: false)
        }
    }
    open override var textAlignment: NSTextAlignment {
        didSet {
            self.placeholderLabel.textAlignment = self.textAlignment
        }
    }
    
    @objc func textFieldDidChange(hidePlaceHolder:Bool) {
        if (self.text?.count ?? 0) > 0 || hidePlaceHolder{
            placeholderLabel.isHidden = true
        }else {
            placeholderLabel.isHidden = false
        }
    }
    open override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.width += self.padding.left + self.padding.right
        size.height += self.padding.top + self.padding.bottom
        return size
    }
    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        var b = bounds
        b.size.width -= self.padding.left + self.padding.right
        b.size.height -= self.padding.top + self.padding.bottom
        var rect = super.textRect(forBounds: b)
        rect.origin.x += self.padding.left
        rect.origin.y += self.padding.top
        return rect
    }
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var b = bounds
        b.size.width -= self.padding.left + self.padding.right
        b.size.height -= self.padding.top + self.padding.bottom
        var rect = super.editingRect(forBounds: b)
        rect.origin.x += self.padding.left
        rect.origin.y += self.padding.top
        return rect
    }
}
extension EasyBuildable where Self: UIView {
    public static func easyText(_ styles: EasyStyleSetting<EasyTextField>...) -> EasyTextField {
        return EasyTextField().easy(styles: styles)
    }
}
extension EasyStyleSetting where TargetType: EasyTextField {
    public static func placeholder(style:EasyStyleSetting<UILabel>...) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            style.forEach({ $0.action(target.placeholderLabel) })
        })
    }
    public static func padding(_ padding:UIEdgeInsets) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.padding = padding
        })
    }
}
