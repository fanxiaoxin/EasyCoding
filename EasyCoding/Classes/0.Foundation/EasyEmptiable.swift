//
//  Emptiable.swift
//  EasyCoding
//
//  Created by 范晓鑫 on 2020/6/25.
//

import UIKit

// MARK: - 内容可空协议

///代表可空内容，如空字符串、空数组、空字典等有实体但无内容的情况
/**
 * 不同于Nullable，后者指没有实例，前者指有实例但具体内容为空
 */
public protocol EasyEmptiable {
    ///内容是否为空
    var isEmpty: Bool { get }
}

// MARK: - 默认重载基础类型

extension String: EasyEmptiable {}
extension Array: EasyEmptiable {
    public var isEmpty: Bool {
        return self.count == 0
    }
}
extension Dictionary: EasyEmptiable {
    public var isEmpty: Bool {
        return self.count == 0
    }
}
extension Data: EasyEmptiable {
    public var isEmpty: Bool {
        return self.count == 0
    }
}

// MARK: - 可空类型也可直接.isEmpty来调用，即使为nil也会返回true，前提是强制不加问号

extension Optional: EasyEmptiable {
    public var isEmpty: Bool {
        switch self {
        case .none: return true
        case let .some(value): return (value as? EasyEmptiable)?.isEmpty ?? false
        }
    }
}

///自定义操作符，若左边为空则取右边，否则取左边
infix operator ???
extension Optional where Wrapped: EasyEmptiable {
    @inlinable public static func ??? (lhs: Self, rhs: Wrapped) -> Wrapped {
        if let value = lhs, !value.isEmpty {
            return value
        }
        return rhs
    }
}
extension EasyEmptiable {
    @inlinable public static func ??? (lhs: Self, rhs: Self) -> Self {
        if !lhs.isEmpty {
            return lhs
        }
        return rhs
    }
}
