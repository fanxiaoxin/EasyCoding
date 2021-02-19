//
//  EasyThemeSpecialSetting.swift
//  EasyCoding
//
//  Created by JY_NEW on 2021/1/9.
//

import Foundation

///可设置颜色表
public protocol EasyThemeColorMapped {
    associatedtype ColorType: EasyThemeValueType where ColorType.RawValue == UIColor
}
extension EasyThemeSetter where ManagerType: EasyThemeColorMapped {
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
public protocol EasyThemeStringMapped {
    associatedtype StringType: EasyThemeValueType where StringType.RawValue == String
}
extension EasyThemeSetter where ManagerType: EasyThemeStringMapped {
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
public protocol EasyThemeImageMapped {
    associatedtype ImageType: EasyThemeValueType where ImageType.RawValue == UIImage?
}
extension EasyThemeSetter where ManagerType: EasyThemeImageMapped {
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
