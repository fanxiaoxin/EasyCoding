//
//  FXEventManagerType.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/4/19.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import Foundation

///管理单个事件类型下多个Handler，可单独使用，一般用于非枚举事件，本身就代表一个事件时EventyType传ECNull
public protocol ECEventManagerType {
    associatedtype EventType: ECEventType
    
    ///添加事件处理
    func add<HandlerType: ECEventHandlerType>(handler:HandlerType) where HandlerType.EventType == EventType
    ///移除事件
    func removeAll(where block: (_ handler:ECEventHandlerBaseType) -> Bool)
    ///移除所有事件
    func removeAllHandlers()
    
    ///触发事件
    func fire(for event: EventType)
    ///中断事件处理
    func abort()
}
extension ECEventManagerType {
    ///移除事件
    func remove<HandlerType: ECEventHandlerType>(handler:HandlerType) where HandlerType.EventType == EventType {
        self.removeAll { (h) -> Bool in
            return (h as? HandlerType) == handler
        }
    }
}
extension ECEventManagerType where EventType == ECNull {
    ///触发事件
    func fire() {
        self.fire(for: .null)
    }
}

extension ECEventManagerType {
    public static func +=<HandlerType: ECEventHandlerType> (left: Self, right: HandlerType) where HandlerType.EventType == EventType {
        return left.add(handler: right)
    }
    public static func -=<HandlerType: ECEventHandlerType> (left: Self, right: HandlerType) where HandlerType.EventType == EventType {
        return left.remove(handler: right)
    }
}
