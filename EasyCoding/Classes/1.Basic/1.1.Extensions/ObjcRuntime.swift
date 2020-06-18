//
//  ObjcRuntime.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/4/19.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import Foundation

extension EC.NamespaceImplement where Base: NSObject {
    public func getAssociated<T>(object key: String) -> T? {
        if let idx = UnsafeRawPointer(bitPattern: key.hashValue) {
            return objc_getAssociatedObject(self.base, idx) as? T
        }else{
            return nil
        }
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
