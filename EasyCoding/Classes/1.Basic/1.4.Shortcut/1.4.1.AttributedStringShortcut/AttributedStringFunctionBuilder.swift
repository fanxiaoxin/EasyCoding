//
//  AttributedStringFunctionBuilder.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/5.
//

import UIKit


@_functionBuilder
struct ECAttributedStringBuilder {
    static func buildBlock() -> ECAttributedString {
        return ECAttributedString(stringLiteral: "")
    }
    static func buildBlock(_ string: String) -> ECAttributedString {
        return ECAttributedString(stringLiteral: string)
    }
    static func buildBlock(_ strings: ECAttributedString...) -> ECAttributedString {
        return strings[0]
    }
    static func buildIf(_ string: ECAttributedString?) -> ECAttributedString?  {
        return string
    }
    static func buildEither(first: ECAttributedString) -> ECAttributedString {
        return first
    }
    static func buildEither(second: ECAttributedString) -> ECAttributedString {
        return second
    }
}
extension NSAttributedString {
    public static func easy(style: ECStringAttribute..., @ECAttributedStringBuilder content: () -> ECAttributedString) -> NSMutableAttributedString {
        return content().attributedString
    }
}
