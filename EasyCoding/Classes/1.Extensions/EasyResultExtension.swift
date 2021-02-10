//
//  EasyResultExtension.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/25.
//

import UIKit

public struct EasyResultExtension<Success, Failure: Error>: EasyTypeWrapperProtocol {
    public let base: Result<Success, Failure>
    public init(value: Result<Success, Failure>) {
        self.base = value
    }
}

extension Result {
    public var easy: EasyResultExtension<Success, Failure> {
        return EasyResultExtension (value: self)
    }
    public static var easy: EasyResultExtension<Success, Failure>.Type {
        return EasyResultExtension.self
    }
}
extension EasyResultExtension {
    ///成功操作
    @discardableResult
    public func success(_ action: (Success) -> Void) -> Self {
        switch self.base {
        case let .success(value): action(value)
        default: break
        }
        return self
    }
    ///失败操作
    @discardableResult
    public func failure(_ action: (Error) -> Void) -> Self {
        switch self.base {
        case let .failure(error): action(error)
        default: break
        }
        return self
    }
}
