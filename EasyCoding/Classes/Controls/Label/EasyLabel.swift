
//
//  Label.swift
//  EasyKit
//
//  Created by Fanxx on 2018/4/11.
//  Copyright © 2018年 fanxx. All rights reserved.
//

import UIKit

open class EasyLabel: UILabel {
    ///文字描边大小
    open var outlinedSize: CGFloat = 0
    ///文字描边颜色
    open var outlinedColor: UIColor = UIColor.clear
    ///内边距
    open var padding: UIEdgeInsets = UIEdgeInsets.zero
    ///斜体
    open var isItalic = false {
        didSet{
            if (self.isItalic) {
                let matrix = CGAffineTransform(a: 1, b: 0, c: CGFloat(tanf(Float(-10 * Double.pi / 180))), d: 1, tx: 0, ty: 0)
                self.transform = matrix
            }else{
                self.transform = CGAffineTransform.identity;
            }
        }
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.load()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.load()
    }
    func load() {
        self.clipsToBounds = false
    }
    open override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.width += self.padding.left + self.padding.right
        size.height += self.padding.top + self.padding.bottom
        return size
    }
    open override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var b = bounds
        b.size.width -= self.padding.left * 2
        var rect = super.textRect(forBounds: b, limitedToNumberOfLines: numberOfLines)
        rect.origin.x += self.padding.left
        rect.origin.y += self.padding.top
        return rect
    }
    open override func drawText(in rect: CGRect) {
        var r = rect
        r.origin.x += self.padding.left;
        r.origin.y += self.padding.top;
        r.size.width -= self.padding.left + self.padding.right;
        r.size.height -= self.padding.top + self.padding.bottom;
        
        if (self.outlinedSize > 0) {
            let shadowOffset = self.shadowOffset
            let textColor = self.textColor
            
            if let c = UIGraphicsGetCurrentContext() {
                c.setLineWidth(self.outlinedSize)
                c.setLineJoin(.round)
                c.setTextDrawingMode(.stroke)
                
                self.textColor = self.outlinedColor
                super.drawText(in: r)
                
                c.setTextDrawingMode(.fill)
                self.textColor = textColor
                self.shadowOffset = CGSize.zero
                super.drawText(in: r)
                
                self.shadowOffset = shadowOffset
            }
        }else{
            super.drawText(in: r)
        }
    }
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let attrText = self.attributedText {
            if var p = touches.first?.location(in: self) {
                p.x -= self.padding.left
//                p.y -= self.padding.top
                var size = self.sizeThatFits(self.bounds.size)
                size.width -= self.padding.left + self.padding.right
                p.y -= (self.bounds.size.height - size.height) / 2
//                size.height -= self.padding.top + self.padding.bottom
                let at = attrText.easy.attr(.paragraph(.lineBreak(self.lineBreakMode)))
                if let f = self.font { at.easy.attr(.font(f)) }
                if let idx = at.easy.characterIndex(at: p, for: size, numberOfLines: self.numberOfLines) {
                    if let eventHandler = attrText.attribute(EasyEventAttributedStringKey, at: idx, effectiveRange: nil) as? (()->Void) {
                        eventHandler()
                    }
                }
            }
        }
        super.touchesBegan(touches, with: event)
    }
}
extension EasyBuildable where Self: UIView {
    public static func easyLabel(_ styles: EasyStyleSetting<EasyLabel>...) -> EasyLabel {
        return EasyLabel().easy(styles: styles)
    }
}
extension EasyStyleSetting where TargetType: EasyLabel {
    public static func italic(_ italic:Bool = true) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.isItalic = italic
        })
    }
    public static func outline(_ size:CGFloat = 1) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.outlinedSize = size
        })
    }
    public static func outline(color:UIColor) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.outlinedColor = color
        })
    }
    public static func padding(_ padding:UIEdgeInsets) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.padding = padding
        })
    }
}

public let EasyEventAttributedStringKey = NSAttributedString.Key("EasyEvent")

extension EasyStringAttribute {
    ///链接，只有EasyLabel能响应
    public static func event(_ handler: @escaping ()-> Void) -> EasyStringAttribute {
        return .init(EasyEventAttributedStringKey, handler)
    }
}
