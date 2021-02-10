//
//  EasyArrayExtension.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/10.
//

import UIKit

extension Array {
    ///若没有返回nil，可用负数
    public func easy(_ index: Int) -> Element? {
        var i = index
        if index < 0 {
            i = self.count + index
        }
        if i.easy.isBetween(-1, self.count) {
            return self[i]
        }
        return nil
    }
}
extension EasyArray {
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
