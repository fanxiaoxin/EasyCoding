//
//  ObjcRuntime.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/4/19.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import Foundation
import JRSwizzle

extension EC.NamespaceImplement where Base: NSObject {
    public func getAssociatedObject(_ key: String) -> Any? {
        if let idx = UnsafeRawPointer(bitPattern: key.hashValue) {
            return objc_getAssociatedObject(self.base, idx)
        }else{
            return nil
        }
    }
    public func getAssociated<T>(object key: String) -> T? {
        return self.getAssociatedObject(key) as? T
    }
    public func setAssociated<T>(object:T, key: String) {
        if let idx = UnsafeRawPointer(bitPattern: key.hashValue) {
            objc_setAssociatedObject(self.base, idx, object, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    public func setWeakAssociated<T>(object:T, key: String) {
        if let idx = UnsafeRawPointer(bitPattern: key.hashValue) {
            objc_setAssociatedObject(self.base, idx, object, .OBJC_ASSOCIATION_ASSIGN);
        }
    }
    public func removeAssociated(object key: String) {
        if let idx = UnsafeRawPointer(bitPattern: key.hashValue) {
            objc_setAssociatedObject(self.base, idx, nil, .OBJC_ASSOCIATION_ASSIGN);
        }
    }
    ///黑魔法，切换实例方法
    public static func swizzle(_ method: Selector, to newMethod:Selector) {
        try? Self.Base.jr_swizzleMethod(method, withMethod: newMethod)
    }
    ///黑魔法，切换类方法
    public static func swizzle(class method: Selector, to newMethod:Selector) {
        try? Self.Base.jr_swizzleClassMethod(method, withClassMethod: newMethod)
    }
}
///用于线程锁
fileprivate let __ecCreateSingletonLockObject: Int = 0

extension EasyCoding {
    ///线程安全的创建单例对象
    public static func createSingleton(getter: () -> Base?, setter: (Base) -> Void, creation: () -> Base) -> Base {
        if let obj = getter() {
            return obj
        }else{
            objc_sync_enter(__ecCreateSingletonLockObject)
            defer { objc_sync_exit(__ecCreateSingletonLockObject) }
            if let obj = getter() {
                return obj
            }else{
                let obj = creation()
                setter(obj)
                return obj
            }
        }
    }
}
extension EasyCoding where Base: ECEmptyInstantiable {
    ///线程安全的创建单例对象
    public static func createSingleton(getter: () -> Base?, setter: (Base) -> Void) -> Base {
        return self.createSingleton(getter: getter, setter: setter, creation: { Base() })
    }
}

fileprivate var __econceTracker = [String]()

extension EasyCoding {
    ///线程安全只执行一次
    public static func once(file: String = #file, function: String = #function, line: Int = #line, block:()->Void) {
        let token = file + ":" + function + ":" + String(line)
        once(token: token, block: block)
    }
    public static func once(token: String, block:()->Void) {
        if __econceTracker.contains(token) { return }
        objc_sync_enter(self.Base)
        defer { objc_sync_exit(self.Base) }
        if __econceTracker.contains(token) { return }
        __econceTracker.append(token)
        block()
    }
}


///用于线程锁
fileprivate let __ecPropertyBindLockObject: Int = 0

extension EasyCoding where Base: NSObject {
    ///线程安全的给对象绑定属性，若为空则创建，否则返回
    public func bindAssociatedObject<T>(_ key: String, creation: () -> T) -> T {
        if let obj: T = self.getAssociated(object: key) {
            return obj
        }else{
            objc_sync_enter(__ecPropertyBindLockObject)
            defer { objc_sync_exit(__ecPropertyBindLockObject) }
            if let obj: T = self.getAssociated(object: key) {
                return obj
            }else{
                let obj = creation()
                self.setAssociated(object: obj, key: key)
                return obj
            }
        }
    }
    ///线程安全的给对象绑定属性，若为空则创建，否则返回
    public func bindAssociatedObject<T: ECEmptyInstantiable>(_ key: String) -> T {
        return self.bindAssociatedObject(key, creation: { T() })
    }
}

extension EC {
    ///提供ObjC调用继承自NSObject的Swift类的方法，防止有些类使用了Swift的特性导致对ObjC类不可见
    ///params传的属性需在Swift中添加@objc标记
    public static func create<T: NSObject>(object name: String, params: [String: Any]? = nil) -> T? {
        if let cls = NSClassFromString("\(Bundle.main.easy.namespace).\(name)") as? T.Type {
            let obj = cls.init()
            if let ps = params {
                obj.setValuesForKeys(ps)
            }
            return obj
        }
        return nil
    }
}
extension NSObject {
    ///提供ObjC调用继承自NSObject的Swift类的方法，防止有些类使用了Swift的特性导致对ObjC类不可见
    @objc public class func easyCreate(_ name: String) -> Self? {
        return EC.create(object: name)
    }
    ///提供ObjC调用继承自NSObject的Swift类的方法，防止有些类使用了Swift的特性导致对ObjC类不可见
    @objc public class func easyCreate(_ name: String, params: [String: Any]) -> Self? {
        return EC.create(object: name, params: params)
    }
}
