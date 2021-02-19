//
//  ClampingProperty.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/4.
//

import Foundation

extension EasyProperty {
    ///限制在最大最小值中间
    @propertyWrapper
    public struct Clamping<Value: Comparable> {
        public var value: Value
        public var min: Value
        public var max: Value
        
        public init(wrappedValue: Value, min: Value, max: Value) {
            value = wrappedValue
            self.min = min
            self.max = max
            assert(value >= min && value <= max)
        }
        
        public var wrappedValue: Value {
            get { return value }
            set {
                if newValue < min {
                    value = min
                } else if newValue > max {
                    value = max
                } else {
                    value = newValue
                }
            }
        }
    }
}
