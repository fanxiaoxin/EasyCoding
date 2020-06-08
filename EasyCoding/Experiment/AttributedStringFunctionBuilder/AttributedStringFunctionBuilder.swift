//
//  AttributedStringFunctionBuilder.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/5.
//

import UIKit

@_functionBuilder
public struct ECAttributedStringBuilder {
    public static func buildBlock() -> Segment {
        return Segment()
    }
    public static func buildBlock(_ segments: Segment...) -> Segment {
        let segment = Segment()
        segment.segments = segments
        return segment
    }
    public static func buildIf(_ segment: Segment?) -> Segment?  {
        return segment
    }
    public static func buildEither(first: Segment) -> Segment {
        return first
    }
    public static func buildEither(second: Segment) -> Segment {
        return second
    }
}
extension NSAttributedString {
    public static func easyBuild(@ECAttributedStringBuilder content:  () -> ECAttributedStringBuilder.Segment) -> NSMutableAttributedString {
        return content().attributedString
    }
}
