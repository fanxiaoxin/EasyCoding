//
//  TrimmedProperty.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/4.
//

import Foundation

extension ECProperty {
    ///自动去除字条串首尾的空字符或指定字符
    @propertyWrapper
    public struct Trimmed {
        private(set) var value: String = ""
        private let characterSet: CharacterSet

        public var wrappedValue: String {
            get { value }
            set { value = newValue.trimmingCharacters(in: characterSet) }
        }

        public init(wrappedValue: String = "", chars: CharacterSet = .whitespacesAndNewlines) {
            self.characterSet = chars
            self.wrappedValue = wrappedValue
        }
    }
}

extension ECProperty {
    ///该标记的字符串比较时不区分大小写
    @propertyWrapper
    public struct CaseInsensitive<Value: StringProtocol> {
        public var wrappedValue: Value
        public init(wrappedValue: Value) {
            self.wrappedValue = wrappedValue
        }
    }
}
extension ECProperty.CaseInsensitive: Comparable {
    private func compare(_ other: ECProperty.CaseInsensitive<Value>) -> ComparisonResult {
        wrappedValue.caseInsensitiveCompare(other.wrappedValue)
    }

    public static func == (lhs: ECProperty.CaseInsensitive<Value>, rhs: ECProperty.CaseInsensitive<Value>) -> Bool {
        lhs.compare(rhs) == .orderedSame
    }

    public static func < (lhs: ECProperty.CaseInsensitive<Value>, rhs: ECProperty.CaseInsensitive<Value>) -> Bool {
        lhs.compare(rhs) == .orderedAscending
    }

    public static func > (lhs: ECProperty.CaseInsensitive<Value>, rhs: ECProperty.CaseInsensitive<Value>) -> Bool {
        lhs.compare(rhs) == .orderedDescending
    }
}
