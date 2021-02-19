//
//  UndoRedoProperty.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/4.
//
import Foundation

extension EasyProperty {
    ///自动记录历史值
    @propertyWrapper
    public struct Undo<Value> {
        
        var index: Int
        var values: [Value]
        
        public init(wrappedValue: Value) {
            self.values = [wrappedValue]
            self.index = 0
        }
        
        public var wrappedValue: Value {
            get {
                values[index]
            }
            set {
                if canRedo {
                    values = Array(values.prefix(through: index))
                }
                values.append(newValue)
                index += 1
            }
        }
        public var canUndo: Bool {
            return index > 0
        }
        public var canRedo: Bool {
            return index < (values.endIndex - 1)
        }
        @discardableResult
        public mutating func undo() -> Bool {
            guard canUndo else { return false }
            index -= 1
            return true
        }
        @discardableResult
        public mutating func redo() -> Bool {
            guard canRedo else { return false }
            index += 1
            return true
        }
        public mutating func reset() {
            values = [values[index]]
            index = 0
        }
    }
}
