//
//  EasyOptionalExtension.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/9/27.
//

import Foundation

extension Optional: Comparable where Wrapped: Comparable {
    @inlinable public static func < (lhs: Self, rhs: Self) -> Bool {
        switch lhs {
        case .none: return true
        case .some(let value): return value < rhs
        }
    }
    @inlinable public static func < (lhs: Self, rhs: Wrapped) -> Bool {
        switch lhs {
        case .none: return true
        case .some(let value): return value < rhs
        }
    }
    @inlinable public static func < (lhs: Wrapped, rhs: Self) -> Bool {
        switch rhs {
        case .none: return false
        case .some(let value): return lhs < value
        }
    }
    @inlinable public static func > (lhs: Self, rhs: Self) -> Bool {
        switch lhs {
        case .none: return false
        case .some(let value): return value > rhs
        }
    }
    @inlinable public static func > (lhs: Self, rhs: Wrapped) -> Bool {
        switch lhs {
        case .none: return false
        case .some(let value): return value > rhs
        }
    }
    @inlinable public static func > (lhs: Wrapped, rhs: Self) -> Bool {
        switch rhs {
        case .none: return true
        case .some(let value): return lhs > value
        }
    }
    @inlinable public static func <= (lhs: Self, rhs: Self) -> Bool {
        return !(lhs > rhs)
    }
    @inlinable public static func <= (lhs: Self, rhs: Wrapped) -> Bool {
        return !(lhs > rhs)
    }
    @inlinable public static func <= (lhs: Wrapped, rhs: Self) -> Bool {
        return !(lhs > rhs)
    }
    @inlinable public static func >= (lhs: Self, rhs: Self) -> Bool {
        return !(lhs < rhs)
    }
    @inlinable public static func >= (lhs: Self, rhs: Wrapped) -> Bool {
        return !(lhs < rhs)
    }
    @inlinable public static func >= (lhs: Wrapped, rhs: Self) -> Bool {
        return !(lhs < rhs)
    }
}
