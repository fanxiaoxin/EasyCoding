//
//  Regex.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/6.
//

import Foundation

///提供正则的简化方式
public struct ECRegex: ExpressibleByStringLiteral {
    private var expression: NSRegularExpression
    
    public init(stringLiteral value: String) {
        do {
            self.expression = try NSRegularExpression(pattern: value, options: [])
        } catch {
            preconditionFailure("expression initialize failure, reason: \(error)")
        }
    }
    public func match(_ value: String) -> Bool {
        var index = 0
        var counter = 0
        outer: while case 0..<value.count = index {
            let shouldPattern = expression.numberOfMatches(
                in: value,
                options: [],
                range: NSRange(index..<value.count)
            )
            if shouldPattern == 0 {
                break outer
            } else {
                index += 1
                counter += 1
            }
        }
        if counter == value.count {
            return true
        } else {
            return false
        }
    }
    
}
extension ECRegex: Equatable {
    public static func ~= (pattern: ECRegex, value: String) -> Bool {
        return pattern.match(value)
    }
    public static func == (lhs: String, rhs: ECRegex) -> Bool {
        return rhs.match(lhs)
    }
    public static func == (lhs: ECRegex, rhs: String) -> Bool {
        return lhs.match(rhs)
    }
}

extension EC.NamespaceImplement where Base == String {
    public func match(_ regex: String) -> Bool {
        return ECRegex(stringLiteral: regex).match(self.base)
    }
}

extension ECRegex {
    ///只包含数字
    public static let numberOnly: ECRegex = "^\\d*$"
    ///只包含字母
    public static let letterOnly: ECRegex = "^[a-zA-Z]*$"
    ///只包含小字母
    public static let LowercaseLetterOnly: ECRegex = "^[a-z]*$"
    ///只包含大字母
    public static let uppercaseLetterOnly: ECRegex = "^[A-Z]*$"
}
