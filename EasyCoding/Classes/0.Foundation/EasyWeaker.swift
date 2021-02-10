//
//  Weaker.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/11/19.
//

import UIKit

///用于保存弱对象
public struct EasyWeaker<T: AnyObject> {
    public weak var obj: T?
}

///保存弱对象，并在对象销毁时自动清除对象
open class EasyWeakerArray<T: AnyObject> {
    private var weakers: [EasyWeaker<T>] = []
    public init() {
        
    }
    ///添加对象
    open func append(_ obj: T) {
        self.checkObjectsAliving()
        let weaker = EasyWeaker(obj: obj)
        self.weakers.append(weaker)
    }
    ///移除对象
    open func remove(_ obj: T) -> T? {
        if let idx = self.weakers.firstIndex(where: { $0.obj === obj }) {
            return self.weakers.remove(at: idx).obj
        }
        return nil
    }
    ///检查对象是否存在，若不存在则移除
    open func checkObjectsAliving() {
        self.weakers.removeAll(where: { $0.obj == nil })
    }
    ///循环操作对象
    open func forEach(_ body: (T) throws -> Void) rethrows {
        self.checkObjectsAliving()
        try self.weakers.map( { $0.obj! }).forEach(body)
    }
    ///循环操作对象
    open func forEach<Type>(_ body: (Type) throws -> Void) rethrows {
        self.checkObjectsAliving()
        try self.weakers.forEach { (weaker) in
            if let t = weaker.obj as? Type {
                try body(t)
            }
        }
    }
}
