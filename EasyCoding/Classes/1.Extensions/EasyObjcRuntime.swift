//
//  ObjcRuntime.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/4/19.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import Foundation

extension EasyCoding where Base: NSObject {
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
            objc_setAssociatedObject(self.base, idx, object, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    public func setWeakAssociated<T>(object:T, key: String) {
        if let idx = UnsafeRawPointer(bitPattern: key.hashValue) {
            objc_setAssociatedObject(self.base, idx, object, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    public func removeAssociated(object key: String) {
        if let idx = UnsafeRawPointer(bitPattern: key.hashValue) {
            objc_setAssociatedObject(self.base, idx, nil, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    ///黑魔法，切换实例方法
    @discardableResult
    public static func swizzle(_ originalSel: Selector, to newSel:Selector) -> Bool {
        guard let originalMethod = class_getInstanceMethod(self.Base, originalSel),
              let newMethod = class_getInstanceMethod(self.Base, newSel) else {
            return false
        }
        
        class_addMethod(self.Base,
                        originalSel,
                        class_getMethodImplementation(self.Base, originalSel)!,
                        method_getTypeEncoding(originalMethod))
        class_addMethod(self.Base,
                        newSel,
                        class_getMethodImplementation(self.Base, newSel)!,
                        method_getTypeEncoding(newMethod));
        
        method_exchangeImplementations(class_getInstanceMethod(self.Base, originalSel)!,
                                       class_getInstanceMethod(self.Base, newSel)!)
        
        return true
    }
    ///黑魔法，切换类方法
    @discardableResult
    public static func swizzle(class originalSel: Selector, to newSel:Selector) -> Bool {
        let cls: AnyClass? = object_getClass(self.Base)
        guard let originalMethod = class_getInstanceMethod(cls, originalSel),
              let newMethod = class_getInstanceMethod(cls, newSel) else {
            return false
        }
        method_exchangeImplementations(originalMethod, newMethod)
        return true
    }
}
///用于线程锁
fileprivate let __easyCreateSingletonLockObject: Int = 0

extension EasyCoding {
    ///线程安全的创建单例对象
    public static func createSingleton(getter: () -> Base?, setter: (Base) -> Void, creation: () -> Base) -> Base {
        if let obj = getter() {
            return obj
        }else{
            objc_sync_enter(__easyCreateSingletonLockObject)
            defer { objc_sync_exit(__easyCreateSingletonLockObject) }
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
extension EasyCoding where Base: EasyEmptyInstantiable {
    ///线程安全的创建单例对象
    public static func createSingleton(getter: () -> Base?, setter: (Base) -> Void) -> Base {
        return self.createSingleton(getter: getter, setter: setter, creation: { Base() })
    }
}

fileprivate var __easyOnceTracker = [String]()

extension EasyCoding {
    ///线程安全只执行一次
    public static func once(file: String = #file, function: String = #function, line: Int = #line, block:()->Void) {
        let token = file + ":" + function + ":" + String(line)
        once(token: token, block: block)
    }
    public static func once(token: String, block:()->Void) {
        if __easyOnceTracker.contains(token) { return }
        objc_sync_enter(self.Base)
        defer { objc_sync_exit(self.Base) }
        if __easyOnceTracker.contains(token) { return }
        __easyOnceTracker.append(token)
        block()
    }
}


///用于线程锁
fileprivate let __easyPropertyBindLockObject: Int = 0

extension EasyCoding where Base: NSObject {
    ///线程安全的给对象绑定属性，若为空则创建，否则返回
    public func bindAssociatedObject<T>(_ key: String, creation: () -> T) -> T {
        if let obj: T = self.getAssociated(object: key) {
            return obj
        }else{
            objc_sync_enter(__easyPropertyBindLockObject)
            defer { objc_sync_exit(__easyPropertyBindLockObject) }
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
    public func bindAssociatedObject<T: EasyEmptyInstantiable>(_ key: String) -> T {
        return self.bindAssociatedObject(key, creation: { T() })
    }
}

extension Easy {
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
        return Easy.create(object: name)
    }
    ///提供ObjC调用继承自NSObject的Swift类的方法，防止有些类使用了Swift的特性导致对ObjC类不可见
    @objc public class func easyCreate(_ name: String, params: [String: Any]) -> Self? {
        return Easy.create(object: name, params: params)
    }
}
