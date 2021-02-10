//
//  ExpirableProperty.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/4.
//

import UIKit

extension EasyProperty {
    ///指定过期时长变量
    @propertyWrapper
    public struct Expirable<Value> {
        
        let duration: TimeInterval
        
        var storage: (value: Value, expirationDate: Date)?
        
        public init(duration: TimeInterval) {
            self.duration = duration
            storage = nil
        }
        public init(wrappedValue: Value?, duration: TimeInterval) {
            self.duration = duration
            self.wrappedValue = wrappedValue
        }
        
        public var wrappedValue: Value? {
            get {
                isValid ? storage?.value : nil
            }
            set {
                storage = newValue.map { newValue in
                    let expirationDate = Date().addingTimeInterval(duration)
                    return (newValue, expirationDate)
                }
            }
        }
        
        public var isValid: Bool {
            guard let storage = storage else { return false }
            return storage.expirationDate >= Date()
        }
        
        public mutating func set(_ newValue: Value, expirationDate: Date) {
            storage = (newValue, expirationDate)
        }
    }
}
