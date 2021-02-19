//
//  EventSetType.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/4/19.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import Foundation

///事件发布者：管理多种事件下的分发，一般用于枚举事件
public protocol EasyEventPublisherType {
    associatedtype EventType: EasyEventType
    ///根据事件获取管理器
    func manager(for event:EventType, allowNil:Bool) -> EasyEventManagerUnspecialType?
    ///当删除处理时发送一个通知
    func didUnregisterEventHandler(for event: EventType)
}
public extension EasyEventPublisherType {
    ///发送事件
    func send(event: EventType, for parameter: Any = easyNull) {
        self.manager(for: event, allowNil: true)?.fire(for: parameter)
    }
    ///注册事件
    func register(event:EventType, handler:EasyEventHandlerType) {
        return self.manager(for: event, allowNil: false)!.add(handler: handler)
    }
    ///注销事件
    func unregister<HandlerType: EasyEventHandlerType>(event:EventType, handler:HandlerType) where HandlerType: Equatable {
        self.manager(for: event, allowNil: true)?.remove(handler: handler)
        self.didUnregisterEventHandler(for: event)
    }
    ///注销事件
    func unregister(event:EventType) {
        self.manager(for: event, allowNil: true)?.removeAllHandlers()
        self.didUnregisterEventHandler(for: event)
    }
}

