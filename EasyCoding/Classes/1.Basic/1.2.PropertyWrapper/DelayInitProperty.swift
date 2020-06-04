//
//  DelayInitProperty.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/4.
//

import Foundation

extension ECProperty {
    @propertyWrapper
    public struct DelayInit<Value> {
        var storage: Value?
        
        public init() {
            storage = nil
        }
        
        public var wrappedValue: Value {
            get {
                guard let storage = storage else {
                    fatalError("当前访问的值尚未初始化")
                }
                return storage
            }
            set {
                storage = newValue
            }
        }
    }
}
