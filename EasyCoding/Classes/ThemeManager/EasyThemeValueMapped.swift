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
            return nil
        }
        nonmutating  set {
            self.set(kp, value: newValue)
        }
    }
    ///设置颜色
    public subscript(dynamicMember kp: WritableKeyPath<TargetType, CGColor?>) -> ManagerType.ColorType? {
        get {
            return nil
        }
        nonmutating  set {
            if let v = newValue {
                self.set { (target) in
                    var t = target
                    t[keyPath: kp] = v.rawValue.cgColor
                }
            }
        }
    }
    ///设置颜色
    public subscript(dynamicMember kp: WritableKeyPath<TargetType, CGColor>) -> ManagerType.ColorType? {
        get {
            return nil
        }
        nonmutating  set {
            if let v = newValue {
                self.set { (target) in
                    var t = target
                    t[keyPath: kp] = v.rawValue.cgColor
                }
            }
        }
    }
}
extension EasyThemeSetter where TargetType: UIButton, ManagerType: EasyThemeColorMapped {
    ///设置颜色
    public func titleColor(_ color: ManagerType.ColorType, for state: UIControl.State = .normal) {
        self.set { (target) in
            target.setTitleColor(color.rawValue, for: state)
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
extension EasyThemeSetter where TargetType: UIButton, ManagerType: EasyThemeImageMapped {
    ///设置图片
    public func backgroundImage(_ image: ManagerType.ImageType, for state: UIControl.State = .normal) {
        self.set { (target) in
            target.setBackgroundImage(image.rawValue, for: state)
        }
    }
}


///可设置字体表
public protocol EasyThemeFontMapped {
    associatedtype FontType: EasyThemeValueType where FontType.RawValue == UIFont?
}
extension EasyThemeSetter where ManagerType: EasyThemeFontMapped {
    ///设置字体
    public subscript(dynamicMember kp: WritableKeyPath<TargetType, UIFont?>) -> ManagerType.FontType? {
        get {
            return self.get(kp)
        }
        nonmutating  set {
            self.set(kp, value: newValue)
        }
    }
}
