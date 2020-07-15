//
//  ECTextualizable.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/8.
//

import UIKit

///可文本化显示
public protocol ECTextualizable {
    var text: String { get }
}
extension String: ECTextualizable {
    public var text: String { return self }
}
extension URL: ECTextualizable {
    public var text: String { return self.absoluteString }
}
extension Int: ECTextualizable {
    public var text: String { return self.description }
}
extension Int8: ECTextualizable {
    public var text: String { return self.description }
}
extension Int16: ECTextualizable {
    public var text: String { return self.description }
}
extension Int32: ECTextualizable {
    public var text: String { return self.description }
}
extension Int64: ECTextualizable {
    public var text: String { return self.description }
}
extension Float: ECTextualizable {
    public var text: String { return self.description }
}
extension Double: ECTextualizable {
    public var text: String { return self.description }
}
extension Float80: ECTextualizable {
    public var text: String { return self.description }
}
extension Date: ECTextualizable {
    public var text: String { return self.easy.string() }
}
extension NSError: ECTextualizable {
    public var text: String { return self.localizedDescription }
}
extension Error {
    public var text: String {
        return (self as ECTextualizable).text
    }
}
///获取最适合的字条串表示
public func ECText(_ object: Any?) -> String {
    if let obj = object {
        if let o = obj as? ECTextualizable {
            return o.text
        }else if let o = obj as? CustomStringConvertible {
            return o.description
        } else {
            return "\(obj)"
        }
    }else{
        return ""
    }
}
