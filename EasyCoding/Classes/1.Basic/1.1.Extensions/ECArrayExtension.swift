//
//  ECArrayExtension.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/10.
//

import UIKit

extension EC.NamespaceArrayImplement {
    ///将多个数组组合成一个
    public static func union<S>(_ contents: [S?]) -> Base where Self.Element == S.Element, S:Sequence {
        var result = Base()
        for content in contents {
            if let c = content {
                result.append(contentsOf: c)
            }
        }
        return result
    }
    ///将多个数组组合成一个
    public static func union<S>(_ contents: S?...) -> Base where Self.Element == S.Element, S:Sequence {
        return self.union(contents)
    }
    ///将多个数组组合成一个
    public func union<S>(_ contents: S?...) -> Base where Self.Element == S.Element, S:Sequence {
        var result = Base(self.base)
        for content in contents {
            if let c = content {
                result.append(contentsOf: c)
            }
        }
        return result
    }
}
