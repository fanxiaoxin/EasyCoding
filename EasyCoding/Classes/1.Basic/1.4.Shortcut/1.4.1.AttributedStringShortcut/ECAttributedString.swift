//
//  AttributedStringBuilder.swift
//  Alamofire
//
//  Created by Fanxx on 2019/8/23.
//

import UIKit

public class ECAttributedString: ExpressibleByStringInterpolation, StringInterpolationProtocol, CustomStringConvertible {
    
    public typealias StringLiteralType = String
    
    public var string: String
    public var attributes: [ECStringAttribute]?
    
    public var description: String {
        return self.string
    }
    public var attributedString: NSMutableAttributedString {
        let result = NSMutableAttributedString(string: self.string)
        self.attributes?.forEach({ $0.apply(result) })
        return result
    }
    public init(_ string: String) {
           self.string = string
           self.attributes = nil
    }
    public init(string: String, attributes: [ECStringAttribute]?) {
           self.string = string
           self.attributes = attributes
    }
    required public init(stringLiteral value: String) {
        self.string = value
        self.attributes = nil
    }
    required public init(stringInterpolation: ECAttributedString) {
        self.string = stringInterpolation.string
        self.attributes = stringInterpolation.attributes
    }
    required public init(literalCapacity: Int, interpolationCount: Int) {
        self.string = ""
        self.attributes = nil
    }
    
    public func appendLiteral(_ literal:String) {
        self.append(other: ECAttributedString(stringLiteral: literal))
    }

    public func appendInterpolation(string literal:String, _ attributes:ECStringAttribute...) {
        let string = ECAttributedString(string: literal, attributes: attributes)
        self.append(other: string)
    }
    public func appendInterpolation(_ string:ECAttributedString, _ attributes:ECStringAttribute...) {
        if string.attributes != nil {
            string.attributes!.insert(contentsOf: attributes, at: 0)
        }else{
            string.attributes = attributes
        }
        self.append(other: string)
    }
    
    public func appendInterpolation(attachment:NSTextAttachment) {
        self.append(other: .init(string: "", attributes: [.attachment(attachment)]))
    }
    public func appendInterpolation(image:UIImage, bounds:CGRect? = nil) {
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = bounds ?? CGRect(origin: .zero, size: image.size)
        self.appendInterpolation(attachment: attachment)
    }
    public func appendInterpolation(data:Data, type:String) {
         let attachment = NSTextAttachment(data: data, ofType: type)
         self.appendInterpolation(attachment: attachment)
    }
    public func appendInterpolation(file:FileWrapper) {
        let attachment = NSTextAttachment()
        attachment.fileWrapper = file
        self.appendInterpolation(attachment: attachment)
    }
    public func append(other: ECAttributedString) {
        if self.attributes != nil {
            for i in 0..<self.attributes!.count {
                if let range = self.attributes![i].range {
                    if range.length <= 0 {
                        self.attributes![i].range = NSMakeRange(range.location, self.string.count)
                    }
                } else {
                    self.attributes![i].range = NSMakeRange(0, self.string.count)
                }
            }
        }
        if var attrs = other.attributes {
            for i in 0..<attrs.count {
                if let range = attrs[i].range {
                    attrs[i].range = NSMakeRange(self.string.count + range.location , range.length <= 0 ? other.string.count : range.length)
                } else {
                    attrs[i].range = NSMakeRange(self.string.count, other.string.count)
                }
            }
            if self.attributes != nil {
                self.attributes!.append(contentsOf: attrs)
            }else{
                self.attributes = attrs
            }
        }
        self.string += other.string
    }
}

extension ECAttributedString {
    public static func + (lhs: ECAttributedString, rhs: ECAttributedString) -> ECAttributedString {
        lhs.append(other: rhs)
        return lhs
    }
    
    public static func + (lhs: ECAttributedString, rhs: String) -> ECAttributedString {
        return lhs + ECAttributedString(stringLiteral: rhs)
    }
    
    public static func + (lhs: String, rhs: ECAttributedString) -> ECAttributedString {
        return ECAttributedString(stringLiteral: lhs) + rhs
    }
    
    public static func += (lhs: inout ECAttributedString, rhs: ECAttributedString) {
        lhs = lhs + rhs
    }
    
    public static func += (lhs: inout ECAttributedString, rhs: String) {
        lhs = lhs + rhs
    }
}
extension NSAttributedString {
    public static func easy(_ builder: ECAttributedString, _ attrs: ECStringAttribute...) -> NSMutableAttributedString {
        if builder.attributes != nil {
            builder.attributes!.insert(contentsOf: attrs, at: 0)
        }else{
            builder.attributes = attrs
        }
        return builder.attributedString
    }
}
