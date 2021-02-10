//
//  EasyTextualizable.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/8.
//

import UIKit

///可文本化显示
public protocol EasyTextualizable {
    ///可直接显示给用户看的文本
    var friendlyText: String { get }
}
extension String: EasyTextualizable {
    public var friendlyText: String { return self }
}
extension URL: EasyTextualizable {
    public var friendlyText: String { return self.absoluteString }
}
extension Int: EasyTextualizable {
    public var friendlyText: String { return self.description }
}
extension Int8: EasyTextualizable {
    public var friendlyText: String { return self.description }
}
extension Int16: EasyTextualizable {
    public var friendlyText: String { return self.description }
}
extension Int32: EasyTextualizable {
    public var friendlyText: String { return self.description }
}
extension Int64: EasyTextualizable {
    public var friendlyText: String { return self.description }
}
extension Float: EasyTextualizable {
    public var friendlyText: String { return self.description }
}
extension Double: EasyTextualizable {
    public var friendlyText: String { return self.description }
}
extension Date: EasyTextualizable {
    public var friendlyText: String { return self.easy.string() }
}
extension NSError: EasyTextualizable {
    public var friendlyText: String { return self.localizedDescription }
}
extension Error {
    public var friendlyText: String {
        return (self as EasyTextualizable).friendlyText
    }
}
///获取最适合的字条串表示
public func EasyText(_ object: Any?) -> String {
    if let obj = object {
        if let o = obj as? EasyTextualizable {
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
