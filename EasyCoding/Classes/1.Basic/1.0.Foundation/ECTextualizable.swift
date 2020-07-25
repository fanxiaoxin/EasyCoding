//
//  ECTextualizable.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/8.
//

import UIKit

///可文本化显示
public protocol ECTextualizable {
    ///可直接显示给用户看的文本
    var friendlyText: String { get }
}
extension String: ECTextualizable {
    public var friendlyText: String { return self }
}
extension URL: ECTextualizable {
    public var friendlyText: String { return self.absoluteString }
}
extension Int: ECTextualizable {
    public var friendlyText: String { return self.description }
}
extension Int8: ECTextualizable {
    public var friendlyText: String { return self.description }
}
extension Int16: ECTextualizable {
    public var friendlyText: String { return self.description }
}
extension Int32: ECTextualizable {
    public var friendlyText: String { return self.description }
}
extension Int64: ECTextualizable {
    public var friendlyText: String { return self.description }
}
extension Float: ECTextualizable {
    public var friendlyText: String { return self.description }
}
extension Double: ECTextualizable {
    public var friendlyText: String { return self.description }
}
extension Date: ECTextualizable {
    public var friendlyText: String { return self.easy.string() }
}
extension NSError: ECTextualizable {
    public var friendlyText: String { return self.localizedDescription }
}
extension Error {
    public var friendlyText: String {
        return (self as ECTextualizable).friendlyText
    }
}
///获取最适合的字条串表示
public func ECText(_ object: Any?) -> String {
    if let obj = object {
        if let o = obj as? ECTextualizable {
            return o.friendlyText
        }else if let o = obj as? CustomStringConvertible {
            return o.description
        } else {
            return "\(obj)"
        }
    }else{
        return ""
    }
}
