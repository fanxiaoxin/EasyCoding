//
//  AttributedStringFunctionBuilderSegmentStyles.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/6.
//

import UIKit

///扩展所有的变量属性
extension ECAttributedStringBuilder.Segment {
    public func color(_ color: UIColor) -> Self {
        return self.appendAttribute(.foregroundColor, color)
    }
}
