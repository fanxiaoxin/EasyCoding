//
//  ObjectHandler.swift
//  EasyCoding
//
//  Created by Fanxx on 2018/3/28.
//  Copyright © 2018年 fanxx. All rights reserved.
//

import Foundation

public struct ECObjectEventHandler<EventType: ECEventType>: ECEventHandlerType {
    ///目标对象
    public weak var target: AnyObject?
    ///目标方法
    public var action: Selector
    
    public func execute(_ event: EventType) {
        _ = target?.perform(self.action, with: event)
    }
    
    public static func == (lhs: ECObjectEventHandler<EventType>, rhs: ECObjectEventHandler<EventType>) -> Bool {
        return lhs.target === rhs.target && lhs.action == rhs.action
    }
}

extension ECEventManagerType {
    ///添加处理事件
    public func add(target: AnyObject, action: Selector) {
        let handler = ECObjectEventHandler<EventType>(target: target, action: action)
        return self.add(handler: handler)
    }
    ///添加处理事件
    public func remove(target: AnyObject, action: Selector) {
        let handler = ECObjectEventHandler<EventType>(target: target, action: action)
        return self.remove(handler:  handler)
    }
    ///添加处理事件
    public func remove(target: AnyObject) {
        return self.removeAll { (handler) -> Bool in
            return (handler as? ECObjectEventHandler<EventType>)?.target === target
        }
    }
}

extension ECEventPublisherType {
    ///注册事件
    public func register(event:EventManagerType.EventType, target:AnyObject, action: Selector) {
        return self.manager(for: event, allowNil: false)!.add(target: target, action: action)
    }
}
