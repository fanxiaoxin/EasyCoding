//
//  EasyDictionaryExtension.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/9/4.
//

import UIKit

extension Dictionary {
    public func easy<T>(_ index: Key) -> T? {
        return self[index] as? T
    }
    public func easy(_ index: Key) -> Int? {
        if let value = self[index] as? Int {
            return value
        }
        if let value = self[index] as? String {
            return Int(value)
        }
        return nil
    }
    public func easy(_ index: Key) -> Float? {
        if let value = self[index] as? Float {
            return value
        }
        if let value = self[index] as? Int {
            return Float(value)
        }
        if let value = self[index] as? String {
            return Float(value)
        }
        return nil
    }
    public func easy(_ index: Key) -> Double? {
        if let value = self[index] as? Double {
            return value
        }
        if let value = self[index] as? Int {
            return Double(value)
        }
        if let value = self[index] as? String {
            return Double(value)
        }
        return nil
    }
}
