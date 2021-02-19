//
//  EnumExtension.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/5/22.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import Foundation

extension Equatable {
    ///判断是否判定枚举的其中一个
    public func `in`(_ values: Self...) -> Bool {
        return values.contains(self)
    }
}
/* 枚举等非具体类型需每次都继承 Easy.Namespace比较麻烦，所以不这么写
extension EasyCoding where Base: Equatable {
    ///判断是否判定枚举的其中一个
    public func `in`(_ values: Self.Base...) -> Bool {
        return values.contains(self.base)
    }
}
*/
