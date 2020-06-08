//
//  EventSetType.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/4/19.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import Foundation

///事件发布者：管理多种事件下的分发，一般用于枚举事件
public protocol ECEventPublisherType {
    associatedtype EventManagerType: ECEventManagerType
    ///根据事件获取管理器
    func manager(for event:EventManagerType.EventType, allowNil:Bool) -> EventManagerType?
    ///当删除处理时发送一个通知
    func didUnregisterEventHandler(for event:EventManagerType.EventType)
}
public extension ECEventPublisherType {
    ///发送事件
    func send(event:EventManagerType.EventType) {
        self.manager(for: event, allowNil: true)?.fire(for: event)
    }
    ///注册事件
    func register<HandlerType: ECEventHandlerType>(event:EventManagerType.EventType, handler:HandlerType) where HandlerType.EventType == EventManagerType.EventType {
        return self.manager(for: event, allowNil: false)!.add(handler: handler)
    }
    ///注销事件
    func unregister<HandlerType: ECEventHandlerType>(event:EventManagerType.EventType, handler:HandlerType) where HandlerType.EventType == EventManagerType.EventType {
        self.manager(for: event, allowNil: false)!.remove(handler: handler)
        self.didUnregisterEventHandler(for: event)
    }
    ///注销事件
    func unregister(event:EventManagerType.EventType) {
        self.manager(for: event, allowNil: false)!.removeAllHandlers()
        self.didUnregisterEventHandler(for: event)
    }
}
