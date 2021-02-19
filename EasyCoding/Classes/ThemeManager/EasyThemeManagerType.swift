//
//  ThemeManagerType.swift
//  Alamofire
//
//  Created by JY_NEW on 2021/1/8.
//

import Foundation

///存储主题设置操作
public class EasyThemeManagerTarget {
    weak var target: AnyObject?
    var setters: [(AnyObject) -> Void] = []
    
    init(target: AnyObject) {
        self.target = target
    }
    ///设置主题
    func set() {
        if let tg = target {
            for setter in setters {
                setter(tg)
            }
        }
    }
}

public protocol EasyThemeManagerType: class {
    ///所有要设置样式的目标
    var targets: [EasyThemeManagerTarget] { get set }
    ///注册主题变更通知
    func register<TargetType>(_ target: TargetType, for setter: @escaping (TargetType) -> Void) where TargetType : AnyObject 
    ///更新主题
    func update()
}

public extension EasyThemeManagerType {
    ///注册主题变更通知
    func register<TargetType>(_ target: TargetType, for setter: @escaping (TargetType) -> Void) where TargetType : AnyObject {
        self.targets.removeAll(where: { $0.target == nil })
        let tg:EasyThemeManagerTarget
        if let t = self.targets.first(where: { $0.target === target }) {
            tg = t
        }else{
            tg = EasyThemeManagerTarget(target: target)
            self.targets.append(tg)
        }
        tg.setters.append { (object) in
            setter(object as! TargetType)
        }
        //注册时执行一次
        setter(target)
    }
    ///更新主题
    func update() {
        self.targets.forEach({ $0.set() })
    }
}
