//
//  TextView.swift
//  EasyKit
//
//  Created by Fanxx on 2019/8/12.
//

import UIKit

public class EasyTextView: UITextView, UITextViewDelegate {
    public override var textContainerInset: UIEdgeInsets {
        didSet {
            self.placeholderLabel.snp.updateConstraints { (make) in
                make.top.equalToSuperview().offset(self.textContainerInset.top)
                make.left.equalToSuperview().offset(self.textContainerInset.left + 4)
                make.right.equalToSuperview().offset(-self.textContainerInset.right - 4)
            }
        }
    }
    ///水印
    public var placeholder: String? {
        get {
          return self.placeholderLabel.text
        }
        set {
            self.placeholderLabel.text = newValue
        }
    }
    ///水印控件
    public let placeholderLabel = UILabel()
    public override var font: UIFont? {
        didSet {
            self.placeholderLabel.font = self.font
        }
    }
    public override var text: String! {
        didSet {
            self.textChanged()
        }
    }
    ///限制字数，小于等于0则不限
    open var wordCount: Int = 0 {
        didSet {
            if self.wordCount > 0 {
                if self.wordCountLabel.superview != self {
                    self.delegate = self
                    self.easy.next(self.wordCountLabel, layout: .right(10), .bottom(5))
                    self.textChanged()
                }
            }else{
                self.wordCountLabel.removeFromSuperview()
            }
        }
    }
    open lazy var wordCountLabel: UILabel = {
        let label = UILabel()
        label.font = self.font
        label.textColor = self.textColor
        return label
    }()
    open var wordCountText: (_ current: Int,_ total: Int) -> NSAttributedString = { current, total in
        return .init(string: "\(current)/\(total)")
    }
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.load()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.load()
    }
    open func load() {
        self.placeholderLabel.numberOfLines = 0
        self.placeholderLabel.font = self.font
        self.placeholderLabel.backgroundColor = .clear
        self.placeholderLabel.alpha = 1
        self.placeholderLabel.textColor = .lightGray
        self.addSubview(self.placeholderLabel)
        self.placeholderLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(4)
            make.right.equalTo(self).offset(-4)
            make.top.equalTo(self).offset(8)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.textChanged), name:UITextView.textDidChangeNotification, object: self)
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: self)
    }
    @objc func textChanged() {
        self.placeholderLabel.alpha = (self.text.count == 0) ? 1 : 0
        if self.wordCount > 0 {
            self.wordCountLabel.attributedText = self.wordCountText(self.text.count, self.wordCount)
        }
    }
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if self.wordCount > 0 {
            let result = (textView.text as NSString).replacingCharacters(in: range, with: text)
            return result.count <= self.wordCount
        }
        return true
    }
//    open override var intrinsicContentSize: CGSize {
//        var size = super.intrinsicContentSize
//        size.width += self.padding.left + self.padding.right
//        size.height += self.padding.top + self.padding.bottom
//        return size
//    }
//    open override func textRect(forBounds bounds: CGRect) -> CGRect {
//        var b = bounds
//        b.size.width -= self.padding.left + self.padding.right
//        b.size.height -= self.padding.top + self.padding.bottom
//        var rect = super.textRect(forBounds: b)
//        rect.origin.x += self.padding.left
//        rect.origin.y += self.padding.top
//        return rect
//    }
//    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
//        var b = bounds
//        b.size.width -= self.padding.left + self.padding.right
//        b.size.height -= self.padding.top + self.padding.bottom
//        var rect = super.editingRect(forBounds: b)
//        rect.origin.x += self.padding.left
//        rect.origin.y += self.padding.top
//        return rect
//    }
}

extension EasyBuildable where Self: UIView {
    public static func easyTextView(_ styles: EasyStyleSetting<EasyTextView>...) -> EasyTextView {
        return EasyTextView().easy(styles: styles)
    }
}

extension EasyStyleSetting where TargetType: EasyTextView {
    ///占位文本
    public static func placeholder(_ text:String?, color: UIColor? = nil, font: UIFont? = nil) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.placeholder = text
            if let c = color {
                target.placeholderLabel.textColor = c
            }
            if let f = font {
                target.placeholderLabel.font = f
            }
        })
    }
    public static func wordCount(_ count: Int) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.wordCount = count
        })
    }
    public static func wordCountLabel(_ styles: EasyStyleSetting<UILabel>...) -> EasyStyleSetting<TargetType> {
           return .init(action: { (target) in
                target.wordCountLabel.easy(styles: styles)
           })
       }
}
