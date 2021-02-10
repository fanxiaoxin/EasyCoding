//
//  TrimmedProperty.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/4.
//

import Foundation

extension EasyProperty {
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

extension EasyProperty {
    ///该标记的字符串比较时不区分大小写
    @propertyWrapper
    public struct CaseInsensitive<Value: StringProtocol> {
        public var wrappedValue: Value
        public init(wrappedValue: Value) {
            self.wrappedValue = wrappedValue
        }
    }
}
extension EasyProperty.CaseInsensitive: Comparable {
    private func compare(_ other: EasyProperty.CaseInsensitive<Value>) -> ComparisonResult {
        wrappedValue.caseInsensitiveCompare(other.wrappedValue)
    }

    public static func == (lhs: EasyProperty.CaseInsensitive<Value>, rhs: EasyProperty.CaseInsensitive<Value>) -> Bool {
        lhs.compare(rhs) == .orderedSame
    }

    public static func < (lhs: EasyProperty.CaseInsensitive<Value>, rhs: EasyProperty.CaseInsensitive<Value>) -> Bool {
        lhs.compare(rhs) == .orderedAscending
    }

    public static func > (lhs: EasyProperty.CaseInsensitive<Value>, rhs: EasyProperty.CaseInsensitive<Value>) -> Bool {
        lhs.compare(rhs) == .orderedDescending
    }
}
