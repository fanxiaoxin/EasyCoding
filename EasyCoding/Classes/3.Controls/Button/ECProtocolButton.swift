//
//  ProtocolButton.swift
//  ECKit
//
//  Created by Fanxx on 2019/12/18.
//

import UIKit

///协议按钮，我同意xxx协议这种按钮
open class ECProtocolButton: ECCheckbox {
    ///根据是否选中该协议而决定是可以操作该按钮
    weak var submitButton: UIButton? {
        didSet {
            self.submitButton?.isEnabled = self.isChecked
        }
    }
    override func touchUpInside() {
        super.touchUpInside()
        self.submitButton?.isEnabled = self.isChecked
    }
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //有事件优先触发事件
        if let tl = self.titleLabel, let p = touches.first?.location(in: tl) {
            if let idx = tl.easy.characterIndex(at: p) {
                if let eventHandler = tl.attributedText?.attribute(ECEventAttributedStringKey, at: idx, effectiveRange: nil) as? (()->Void) {
                    return eventHandler()
                }
            }
        }
        super.touchesBegan(touches, with: event)
    }
    override open func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        var rect = super.imageRect(forContentRect: contentRect)
        let titleRect = super.titleRect(forContentRect: contentRect)
        rect.origin.y = titleRect.origin.y + self.imageEdgeInsets.top
        if let height = self.titleLabel?.font.lineHeight {
            rect.origin.y += max((height - rect.size.height) / 2, 0)
        }
        return rect
    }
}

extension ECBuildable where Self: UIView {
    public static func easyProtocol(_ styles: ECStyleSetting<ECProtocolButton>...) -> ECProtocolButton {
        return ECProtocolButton().easy(styles: styles)
    }
}

extension ECStyleSetting where TargetType: ECProtocolButton {
    public static func submit(_ button:UIButton) -> ECStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.submitButton = button
        })
    }
}
