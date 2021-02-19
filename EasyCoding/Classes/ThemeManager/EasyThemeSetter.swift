//
//  EasyECThemeSetter.swift
//  Alamofire
//
//  Created by JY_NEW on 2021/1/8.
//

import Foundation

///主题设置器
@dynamicMemberLookup
public struct EasyThemeSetter<TargetType: AnyObject, ManagerType: EasyThemeManagerType> {
    ///设置目标
    public let target: TargetType
    ///主题管理器
    public let manager: ManagerType
    public init(target: TargetType, manager: ManagerType) {
        self.target = target
        self.manager = manager
    }
}
extension EasyThemeSetter {
    ///设置主题
    public func set(_ setter: @escaping (TargetType) -> Void) {
        self.manager.register(self.target, for: setter)
    }
}

//动态查找成员，在实现的具体类或结构前面添加@dynamicMemberLookup，可直接通过属性值设置主题
extension EasyThemeSetter {
    internal func get<ValueType: EasyThemeValueType>(_ kp: WritableKeyPath<TargetType, ValueType.RawValue?>) -> ValueType? {
        if let value = self.target[keyPath: kp] {
            return ValueType(rawValue: value)
        }
        return nil
    }
    internal func set<ValueType: EasyThemeValueType>(_ kp: WritableKeyPath<TargetType, ValueType.RawValue?>, value: ValueType?) {
        if let v = value {
            self.set { (target) in
                var t = target
                t[keyPath: kp] = v.rawValue
            }
        }
    }
    internal func get<ValueType: EasyThemeValueType>(_ kp: WritableKeyPath<TargetType, ValueType.RawValue>) -> ValueType? {
        return ValueType(rawValue: self.target[keyPath: kp])
    }
    internal func set<ValueType: EasyThemeValueType>(_ kp: WritableKeyPath<TargetType, ValueType.RawValue>, value: ValueType?) {
        if let v = value {
            self.set { (target) in
                var t = target
                t[keyPath: kp] = v.rawValue
            }
        }
    }
    ///设置属性
    public subscript<ValueType: EasyThemeValueType>(dynamicMember kp: WritableKeyPath<TargetType, ValueType.RawValue?>) -> ValueType? {
        get {
            return self.get(kp)
        }
        nonmutating  set {
            self.set(kp, value: newValue)
        }
    }
    ///设置属性
    public subscript<ValueType: EasyThemeValueType>(dynamicMember kp: WritableKeyPath<TargetType, ValueType.RawValue>) -> ValueType? {
        get {
            return self.get(kp)
        }
        nonmutating  set {
            self.set(kp, value: newValue)
        }
    }
}
