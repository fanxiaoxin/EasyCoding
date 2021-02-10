//
//  StringAttribute.swift
//  Alamofire
//
//  Created by Fanxx on 2019/8/22.
//

import UIKit

public struct EasyStringAttribute {
    public var attributes: [NSAttributedString.Key: Any]
    ///为nil则表示全局
    public var range: NSRange?
    
    public init(_ key: NSAttributedString.Key, _ value: Any, range: NSRange? = nil) {
        self.attributes = [key: value]
        self.range = range
    }
    public init(_ attrs: [NSAttributedString.Key: Any], range: NSRange? = nil) {
        self.attributes = attrs
        self.range = range
    }
    ///指定作用范围, len<=0则代表到结尾
    public static func range(_ loc: Int,_ len: Int,_ attrs: EasyStringAttribute...) -> EasyStringAttribute {
        var values: [NSAttributedString.Key: Any] = [:]
        for a in attrs {
            values.merge(a.attributes) { (v, _) -> Any in return v }
        }
        return .init(values, range: NSMakeRange(loc, len))
    }
    ///指定作用范围, len<=0则代表到结尾
    public static func range(_ range: NSRange,_ attrs: EasyStringAttribute...) -> EasyStringAttribute {
        var values: [NSAttributedString.Key: Any] = [:]
        for a in attrs {
            values.merge(a.attributes) { (v, _) -> Any in return v }
        }
        return .init(values, range: range)
    }
    ///应用
    public func apply(_ string: NSMutableAttributedString) {
        var range: NSRange
        if let r = self.range {
            if r.length <= 0 {
                range = NSMakeRange(r.location, string.length - r.location)
            }else{
                range = r
            }
        }else{
            range = NSMakeRange(0, string.length)
        }
        string.addAttributes(self.attributes, range: range)
    }
}
extension EasyCoding where Base == String {
    public func attr(_ attrs: EasyStringAttribute...) -> NSAttributedString {
        if attrs.count == 0 {
            return NSAttributedString(string: self.base)
        } else if attrs.count == 1 {
            if attrs[0].range == nil {
                return NSAttributedString(string: self.base, attributes: attrs[0].attributes)
            }
        }
        let str = NSMutableAttributedString(string: self.base)
        attrs.forEach({ $0.apply(str) })
        return str
    }
    public func mutableAttr(_ attrs: EasyStringAttribute...) -> NSMutableAttributedString {
        let str = NSMutableAttributedString(string: self.base)
        attrs.forEach({ $0.apply(str) })
        return str
    }
}
extension EasyCoding where Base: NSAttributedString {
    public func attr(_ attrs: EasyStringAttribute...) -> NSMutableAttributedString {
        let str = NSMutableAttributedString(attributedString: self.base)
        attrs.forEach({ $0.apply(str) })
        return str
    }
}
extension EasyCoding where Base: NSMutableAttributedString {
    @discardableResult
    public func attr(_ attrs: EasyStringAttribute...) -> Base {
        attrs.forEach({ $0.apply(self.base) })
        return self.base
    }
    @discardableResult
    public func reg(_ reg: String, options:  NSRegularExpression.Options = .caseInsensitive, _ attrs: EasyStringAttribute...) -> Base {
        var values: [NSAttributedString.Key: Any] = [:]
        for a in attrs {
            values.merge(a.attributes) { (v, _) -> Any in return v }
        }
        
        let reg = try? NSRegularExpression(pattern: reg, options: options)
        reg?.enumerateMatches(in: self.base.string, options: .reportProgress, range: NSRange(location: 0, length: self.base.string.count)) { (result, flags, _) in
            if let r = result {
                EasyStringAttribute(values, range: r.range).apply(self.base)
            }
        }
        return self.base
    }
}
extension Dictionary where Key == NSAttributedString.Key, Value == Any {
    public static func easy(_ attrs: EasyStringAttribute...) -> [NSAttributedString.Key: Any] {
        var result:[NSAttributedString.Key: Any] = [:]
        attrs.forEach({ result.merge($0.attributes, uniquingKeysWith: { $1 })})
        return result
    }
}
