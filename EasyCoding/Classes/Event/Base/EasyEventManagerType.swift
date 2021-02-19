//
//  EasyEventManagerType.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/4/19.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import Foundation

///管理单个事件类型下多个Handler，可单独使用，一般用于非枚举事件，本身就代表一个事件
public protocol EasyEventManagerBaseType {
    ///添加事件处理
    func add(handler:EasyEventHandlerType)
    ///移除事件
    func removeAll(where block: (_ handler:EasyEventHandlerType) -> Bool)
    ///移除所有事件
    func removeAllHandlers()
    ///中断事件处理
    func abort()
}
///管理单个事件类型下多个Handler，可单独使用，一般用于非枚举事件，本身就代表一个事件
public protocol EasyEventManagerType: EasyEventManagerBaseType {
    associatedtype EventParameterType
    ///触发事件
    func fire(for param: EventParameterType)
    
}
extension EasyEventManagerType {
    ///添加处理事件
    public func callAsFunction(_ param: EventParameterType) {
        self.fire(for: param)
    }
}
///管理单个事件类型下多个Handler，可单独使用，一般用于非枚举事件，本身就代表一个事件
public protocol EasyEventManagerUnspecialType: EasyEventManagerBaseType {
    ///触发事件
    func fire(for param: Any)
}
extension EasyEventManagerUnspecialType {
    ///添加处理事件
    public func callAsFunction(_ param: Any) {
        self.fire(for: param)
    }
}
extension EasyEventManagerBaseType {
    ///移除事件
    func remove<HandlerType: EasyEventHandlerType>(handler:HandlerType) where HandlerType: Equatable {
        self.removeAll { (h) -> Bool in
            return (h as? HandlerType) == handler
        }
    }
}

extension EasyEventManagerBaseType {
    public static func += (left: Self, right: EasyEventHandlerType){
        return left.add(handler: right)
    }
    public static func -=<HandlerType: EasyEventHandlerType> (left: Self, right: HandlerType) where HandlerType: Equatable {
        return left.remove(handler: right)
    }
}
