//
//  LazyProperty.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/4.
//

import Foundation

extension EasyProperty {
    ///懒加载
    @propertyWrapper
    enum Lazy<Value> {
      case uninitialized(() -> Value)
      case initialized(Value)

      init(wrappedValue: @autoclosure @escaping () -> Value) {
        self = .uninitialized(wrappedValue)
      }

      var wrappedValue: Value {
        mutating get {
          switch self {
          case .uninitialized(let initializer):
            let value = initializer()
            self = .initialized(value)
            return value
          case .initialized(let value):
            return value
          }
        }
        set {
          self = .initialized(newValue)
        }
      }
    }
}
