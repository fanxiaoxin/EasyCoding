//
//  ObjectHandler.swift
//  EasyCoding
//
//  Created by Fanxx on 2018/3/28.
//  Copyright © 2018年 fanxx. All rights reserved.
//

import Foundation

public struct EasyObjectEventHandler: EasyEventHandlerType, Equatable {
    ///目标对象
    public weak var target: AnyObject?
    ///目标方法
    public var action: Selector
    
    public func execute(_ param: Any) {
        _ = target?.perform(self.action, with: param)
    }
    
    public static func == (lhs: EasyObjectEventHandler, rhs: EasyObjectEventHandler) -> Bool {
        return lhs.target === rhs.target && lhs.action == rhs.action
    }
}

extension EasyEventManagerBaseType {
    ///添加处理事件
    public func add(target: AnyObject, action: Selector) {
        let handler = EasyObjectEventHandler(target: target, action: action)
        self.add(handler: handler)
    }
    ///添加处理事件
    public func remove(target: AnyObject, action: Selector) {
        let handler = EasyObjectEventHandler(target: target, action: action)
        self.remove(handler:  handler)
    }
    ///添加处理事件
    public func remove(target: AnyObject) {
        return self.removeAll { (handler) -> Bool in
            return (handler as? EasyObjectEventHandler)?.target === target
        }
    }
}

extension EasyEventPublisherType {
    ///注册事件
    public func register(event:EventType, target:AnyObject, action: Selector) {
        return self.manager(for: event, allowNil: false)!.add(target: target, action: action)
    }
    ///注销事件
    public func unregister(event:EventType, target: AnyObject, action: Selector) {
        self.manager(for: event, allowNil: true)?.remove(target: target, action: action)
    }
    ///注销事件
    public func unregister(event:EventType, target: AnyObject) {
        self.manager(for: event, allowNil: true)?.remove(target: target)
    }
}
