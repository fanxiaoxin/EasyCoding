//
//  ECThemeSpecialSetting.swift
//  EasyCoding
//
//  Created by JY_NEW on 2021/1/9.
//

import Foundation

///可设置颜色表
public protocol ECThemeColorMapped {
    associatedtype ColorType: ECThemeValueType where ColorType.RawValue == UIColor
}
extension ECThemeSetter where ManagerType: ECThemeColorMapped {
    ///设置颜色
    public subscript(dynamicMember kp: WritableKeyPath<TargetType, UIColor?>) -> ManagerType.ColorType? {
        get {
            return self.get(kp)
        }
        nonmutating  set {
            self.set(kp, value: newValue)
        }
    }
    ///设置颜色
    public subscript(dynamicMember kp: WritableKeyPath<TargetType, UIColor>) -> ManagerType.ColorType? {
        get {
            return self.get(kp)
        }
        nonmutating  set {
            self.set(kp, value: newValue)
        }
    }
}

///可设置字符串表
public protocol ECThemeStringMapped {
    associatedtype StringType: ECThemeValueType where StringType.RawValue == String
}
extension ECThemeSetter where ManagerType: ECThemeStringMapped {
    ///设置文字
    public subscript(dynamicMember kp: WritableKeyPath<TargetType, String?>) -> ManagerType.StringType? {
        get {
            return self.get(kp)
        }
        nonmutating  set {
            self.set(kp, value: newValue)
        }
    }
    ///设置文字
    public subscript(dynamicMember kp: WritableKeyPath<TargetType, String>) -> ManagerType.StringType? {
        get {
            return self.get(kp)
        }
        nonmutating  set {
            self.set(kp, value: newValue)
        }
    }
}

///可设置图片表
public protocol ECThemeImageMapped {
    associatedtype ImageType: ECThemeValueType where ImageType.RawValue == UIImage?
}
extension ECThemeSetter where ManagerType: ECThemeImageMapped {
    ///设置图片
    public subscript(dynamicMember kp: WritableKeyPath<TargetType, UIImage?>) -> ManagerType.ImageType? {
        get {
            return self.get(kp)
        }
        nonmutating  set {
            self.set(kp, value: newValue)
        }
    }
}
