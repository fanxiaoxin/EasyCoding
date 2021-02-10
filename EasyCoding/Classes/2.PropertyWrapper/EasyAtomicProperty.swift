//
//  AtomicProperty.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/4.
//

import Foundation

extension EasyProperty {
    ///多读单写
    @propertyWrapper
    public struct Atomic<Value> {
        let queue = DispatchQueue(label: "Atomic write access queue", attributes: .concurrent)
        var value: Value
        
        public init(wrappedValue: Value) {
            self.value = wrappedValue
        }
        
        public var wrappedValue: Value {
            get {
                return queue.sync { value }
            }
            set {
                queue.sync(flags: .barrier) { value = newValue }
            }
        }
        
        public mutating func mutate(_ mutation: (inout Value) throws -> Void) rethrows {
            return try queue.sync(flags: .barrier) {
                try mutation(&value)
            }
        }
    }
}
