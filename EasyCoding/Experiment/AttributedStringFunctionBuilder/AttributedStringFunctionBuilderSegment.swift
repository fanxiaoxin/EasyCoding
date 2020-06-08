//
//  AttributedStringFunctionBuilderGrammar.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/6.
//

import UIKit

///表示大括号里面代码段，效果：
/// let endString = "end of this"
/// NSAttributedString.easy( {
///     "I'm herer"
///     "for you to see".color(.red).font(size:14)
///     .text(endString)
///     .sub {
///        "sub texts"
///        "sub sub texts".color(.red).font(size:14)        
///        ......
///     }.color(.blue) .font(size: 15)
/// }.color(.blue), .font(size: 3)
extension ECAttributedStringBuilder {
    public final class Segment : ExpressibleByStringLiteral {
        public let string: String?
        public var attributes: [NSAttributedString.Key: Any]?
        public var segments: [Segment]?
        
        public var attributedString: NSMutableAttributedString {
            let string = NSMutableString()
            self.appendString(to: string)
            let result = NSMutableAttributedString(string: string as String)
            self.appendAttributes(to: result, offset: 0)
            return result
        }
        ///在生成AttributedString的过程中先预生计算的字符串(包含子字符串)长度，后面要拿
        private var preparedStringLength: Int = 0
        ///递归串联所有的字符串
        private func appendString(to target: NSMutableString) {
            //先录录添加字符串前的总长度
            let offset = target.length
            if let string = self.string {
                target.append(string)
            }
            if let segments = self.segments {
                for segment in segments {
                    segment.appendString(to: target)
                }
            }
            //添加完后的字符串总长度减去之前记录的就是当前片断的字符串总长度
            self.preparedStringLength = target.length - offset
        }
        ///递归串联所有的样式
        private func appendAttributes(to target: NSMutableAttributedString, offset: Int) {
            if let attrs = self.attributes {
                target.addAttributes(attrs, range: NSMakeRange(offset, self.preparedStringLength))
            }
            if let segments = self.segments {
                for segment in segments {
                    segment.appendAttributes(to: target, offset: offset + self.preparedStringLength)
                }
            }
        }
        public init() {
            self.string = nil
            self.attributes = nil
            self.segments = nil
        }
        ///直接写常量字符串的方式
        public init(stringLiteral value: String) {
            self.string = value
            self.attributes = nil
            self.segments = nil
        }
        ///通过.text来传递变量字符串
        public static func text(_ string: String) -> Self {
            return Self(stringLiteral: string)
        }
        ///通过.sub来包含子代码
        public static func sub(@ECAttributedStringBuilder _ segment: (Segment...) -> Segment) -> Segment {
            return segment()
        }
        ///添加子代码
        @discardableResult
        public func append(segment: Segment) -> Self {
            if self.segments == nil {
                self.segments = [segment]
            }else{
                self.segments!.append(segment)
            }
            return self
        }
        ///添加属性
        @discardableResult
        public func appendAttribute(_ key: NSAttributedString.Key, _ value: Any) -> Self {
            if self.attributes == nil {
                self.attributes = [key: value]
            }else{
                self.attributes![key] = value
            }
            return self
        }
    }
}
