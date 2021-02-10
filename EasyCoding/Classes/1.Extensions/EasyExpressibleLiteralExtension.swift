//
//  StringLiteralExtension.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/6.
//

import UIKit

extension Date: ExpressibleByStringLiteral {
    ///使用"2020-06-06 12:00:00"、"2020-06-06"、"12:00:00"的方式初始化
    public init(stringLiteral value: String) {
        let dateformatter = DateFormatter()
        switch value.count {
        case 19: dateformatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        case 10: dateformatter.dateFormat = "YYYY-MM-dd"
        case 8: dateformatter.dateFormat = "HH:mm:ss"
        default:
            preconditionFailure("This date: \(value) is not invalid")
        }
        guard let date = dateformatter.date(from: value) else {
            preconditionFailure("This date: \(value) is not invalid")
        }
        self = date
    }
}
extension URL: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        guard let url = URL(string: "\(value)") else {
            preconditionFailure("This url: \(value) is not invalid")
        }
        self = url
    }
}

extension URLRequest: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        guard let url = URL(string: "\(value)") else {
            preconditionFailure("This url: \(value) is not invalid")
        }
        self = .init(url: url)
    }
}
