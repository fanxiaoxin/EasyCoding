//
//  EventManager.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/4/19.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import Foundation

///针对某一种事件的管理
open class EasyEventManagerBase: EasyEventManagerBaseType {
    public init() {
        
    }
    ///注册在该事件下的所有处理
    public internal(set) var handlers: [EasyEventHandlerType] = []
    ///中断后续事件的处理，用于事件处理中中断使用，中断过后该值变为NO
    public var isAborting = false
    
    ///添加事件处理
    open func add(handler: EasyEventHandlerType) {
        self.handlers.append(handler)
    }
    ///移除事件
    open func removeAll(where block: (EasyEventHandlerType) -> Bool) {
        self.handlers.removeAll(where: block)
    }
    ///移除所有事件
    open func removeAllHandlers() {
        self.handlers.removeAll()
    }
    ///中断事件处理
    open func abort()  {
        self.isAborting = true
    }
    fileprivate func _fire(for param: Any) {
        for handler in self.handlers {
            handler.execute(param)
            if self.isAborting {
                self.isAborting = false
                break
            }
        }
    }
}
open class EasyEventManagerUnspecial : EasyEventManagerBase, EasyEventManagerUnspecialType {
    ///触发事件
    open func fire(for param: Any) {
        self._fire(for: param)
    }
}
open class EasyEventManager<EventParameterType> : EasyEventManagerBase, EasyEventManagerType {
    ///触发事件
    open func fire(for param: EventParameterType) {
        self._fire(for: param)
    }
}
extension EasyEventManager where EventParameterType == EasyNull {
    public func fire() {
        self.fire(for: easyNull)
    }
    ///添加处理事件
    public func callAsFunction() {
        self.fire(for: easyNull)
    }
}

public typealias EasyEvent<EventParameterType> = EasyEventManager<EventParameterType>
public typealias EasyNoParamEvent = EasyEventManager<EasyNull>
