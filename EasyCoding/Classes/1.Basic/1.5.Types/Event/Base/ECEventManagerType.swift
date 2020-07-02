//
//  ECEventManagerType.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/4/19.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import Foundation

///管理单个事件类型下多个Handler，可单独使用，一般用于非枚举事件，本身就代表一个事件
public protocol ECEventManagerBaseType {
    ///添加事件处理
    func add(handler:ECEventHandlerType)
    ///移除事件
    func removeAll(where block: (_ handler:ECEventHandlerType) -> Bool)
    ///移除所有事件
    func removeAllHandlers()
    ///中断事件处理
    func abort()
}
///管理单个事件类型下多个Handler，可单独使用，一般用于非枚举事件，本身就代表一个事件
public protocol ECEventManagerType: ECEventManagerBaseType {
    associatedtype EventParameterType
    ///触发事件
    func fire(for param: EventParameterType)
    
}
extension ECEventManagerType {
    ///添加处理事件
    public func callAsFunction(_ param: EventParameterType) {
        self.fire(for: param)
    }
}
///管理单个事件类型下多个Handler，可单独使用，一般用于非枚举事件，本身就代表一个事件
public protocol ECEventManagerUnspecialType: ECEventManagerBaseType {
    ///触发事件
    func fire(for param: Any)
}
extension ECEventManagerUnspecialType {
    ///添加处理事件
    public func callAsFunction(_ param: Any) {
        self.fire(for: param)
    }
}
extension ECEventManagerBaseType {
    ///移除事件
    func remove<HandlerType: ECEventHandlerType>(handler:HandlerType) where HandlerType: Equatable {
        self.removeAll { (h) -> Bool in
            return (h as? HandlerType) == handler
        }
    }
}

extension ECEventManagerBaseType {
    public static func += (left: Self, right: ECEventHandlerType){
        return left.add(handler: right)
    }
    public static func -=<HandlerType: ECEventHandlerType> (left: Self, right: HandlerType) where HandlerType: Equatable {
        return left.remove(handler: right)
    }
}
