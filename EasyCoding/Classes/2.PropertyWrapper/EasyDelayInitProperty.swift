//
//  DelayInitProperty.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/4.
//

import Foundation

extension EasyProperty {
    ///延时初始化，调用前必须初始化
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
