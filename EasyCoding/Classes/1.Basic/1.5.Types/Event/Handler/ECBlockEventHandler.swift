//
//  actionHandler.swift
//  EasyCoding
//
//  Created by Fanxx on 2018/3/28.
//  Copyright © 2018年 fanxx. All rights reserved.
//

import UIKit

///Block事件目前不能删除
public struct ECBlockEventHandler: ECEventHandlerType, Equatable {
    public var identifier: String?
    public var action: (Any)->Void
    
    public func execute(_ param: Any) {
        self.action(param)
    }
    public static func == (lhs: ECBlockEventHandler, rhs:ECBlockEventHandler) -> Bool {
        return lhs.identifier != nil && lhs.identifier == rhs.identifier
    }
}
extension ECEventManagerBaseType {
    ///添加处理事件
    public func add(_ identifier: String? = nil, block: @escaping ()->Void) {
        let handler = ECBlockEventHandler(identifier: identifier, action: { _ in
            block()
        })
        self.add(handler: handler)
    }
    public func remove(_ identifier: String) {
        self.removeAll { (handler) -> Bool in
            return (handler as? ECBlockEventHandler)?.identifier == identifier
        }
    }
    public func callAsFunction(_ identifier: String? = nil, block: @escaping ()->Void) {
        self.add(identifier, block: block)
    }
}
extension ECEventManagerType {
    ///添加处理事件
    public func add(_ identifier: String? = nil, block: @escaping (EventParameterType)->Void) {
        let handler = ECBlockEventHandler(identifier: identifier, action: { param in
            block(param as! EventParameterType)
        })
        self.add(handler: handler)
    }
}
extension ECEventManagerUnspecialType {
    ///添加处理事件
    public func add<EventParameterType>(_ identifier: String? = nil, block: @escaping (EventParameterType)->Void) {
        let handler = ECBlockEventHandler(identifier: identifier, action: { param in
            block(param as! EventParameterType)
        })
        self.add(handler: handler)
    }
}

extension ECEventPublisherType {
    ///注册事件
    public func register<EventParameterType>(event:EventType, identifier: String? = nil, block: @escaping (EventParameterType)->Void) {
        self.manager(for: event, allowNil: false)!.add(block: block)
    }
    ///注册事件
    public func register(event:EventType,  identifier: String? = nil, block: @escaping ()->Void) {
        self.manager(for: event, allowNil: false)!.add(block: block)
    }
    ///注销事件
    public func unregister(event:EventType,  identifier: String) {
        self.manager(for: event, allowNil: true)?.remove(identifier)
    }
}

extension ECEventPublisherType {
    ///注册事件
    public func when<EventParameterType>(_ event:EventType, identifier: String? = nil, block: @escaping (EventParameterType)->Void) {
        self.manager(for: event, allowNil: false)!.add(block: block)
    }
}
