//
//  EventManager.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/4/19.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import Foundation

///针对某一种事件的管理
open class ECEventManager<EventType: ECEventType>: ECEventManagerType {
    ///注册在该事件下的所有处理
    public internal(set) var handlers: [ECEventHandlerBaseType] = []
    ///中断后续事件的处理，用于事件处理中中断使用，中断过后该值变为NO
    public var isAborting = false
    
    ///添加事件处理
    open func add<HandlerType: ECEventHandlerType>(handler:HandlerType) where HandlerType.EventType == EventType {
        self.handlers.append(handler)
    }
    ///移除事件
    open func removeAll(where block: (ECEventHandlerBaseType) -> Bool) {
        self.handlers.removeAll(where: block)
    }
    ///移除所有事件
    open func removeAllHandlers() {
        self.handlers.removeAll()
    }
    
    ///触发事件
    open func fire(for event: EventType) {
        for handler in self.handlers {
            handler.execute(event)
            if self.isAborting {
                self.isAborting = false
                break
            }
        }
    }
    ///中断事件处理
    open func abort()  {
        self.isAborting = true
    }
}

public typealias ECEvent = ECEventManager<ECNull>
