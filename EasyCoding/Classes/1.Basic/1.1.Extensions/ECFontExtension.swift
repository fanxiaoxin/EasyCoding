//
//  UIFontExtension.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/8.
//

import UIKit

extension EC.NamespaceImplement where Base == UIFont {
    public var isBold: Bool {
        return self.base.fontDescriptor.symbolicTraits.contains(.traitBold)
    }
    public var isItalic: Bool {
        return self.base.fontDescriptor.symbolicTraits.contains(.traitItalic)
    }
    public var bold: UIFont {
        return UIFont(descriptor: self.base.fontDescriptor.withSymbolicTraits(.traitBold)!, size: self.base.pointSize)
    }
    public var italic: UIFont {
        return UIFont(descriptor: self.base.fontDescriptor.withSymbolicTraits(.traitItalic)!, size: self.base.pointSize)
    }
}
