//
//  actionHandler.swift
//  EasyCoding
//
//  Created by Fanxx on 2018/3/28.
//  Copyright © 2018年 fanxx. All rights reserved.
//

import UIKit

///Block事件目前不能删除
public struct ECBlockEventHandler<EventType: ECEventType>: ECEventHandlerType {
    public var action: (EventType)->Void
    
    public func execute(_ event: EventType) {
        self.action(event)
    }
    public static func == (lhs: ECBlockEventHandler<EventType>, rhs: ECBlockEventHandler<EventType>) -> Bool {
        return false
    }
}
extension ECEventManagerType {
    ///添加处理事件
    public func add(block: @escaping (EventType)->Void) {
        let handler = ECBlockEventHandler<EventType>(action: block)
        return self.add(handler: handler)
    }
    ///添加处理事件
    public func add(block: @escaping ()->Void) {
        let handler = ECBlockEventHandler<EventType>(action:  { _ in
            block()
        })
        return self.add(handler: handler)
    }
    public func callAsFunction(block: @escaping (EventType)->Void) {
        self.add(block: block)
    }
    public func callAsFunction(block: @escaping ()->Void) {
        self.add(block: block)
    }
}

extension ECEventPublisherType {
    ///注册事件
    public func register(event:EventManagerType.EventType, block: @escaping (EventManagerType.EventType)->Void) {
        return self.manager(for: event, allowNil: false)!.add(block: block)
    }
    ///注册事件
    public func register(event:EventManagerType.EventType, block: @escaping ()->Void) {
        return self.manager(for: event, allowNil: false)!.add(block: { _ in
            block()
        })
    }
}
