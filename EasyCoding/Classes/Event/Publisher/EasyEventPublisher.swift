//
//  EventSet.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/4/19.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import UIKit

///事件发布者：管理多种事件下的分发，一般用于枚举事件，一个事件管理者只管理一个事件实例
open class EasyEventPublisher<EventType: EasyEventType>: EasyEventPublisherType where EventType: Hashable {
    public var managers: [EventType: EasyEventManagerUnspecial] = [:]
    ///若该事件的管理器不存在则新建
    public func manager(for event:EventType, allowNil: Bool) -> EasyEventManagerUnspecialType? {
        if let manager =  self.managers[event] {
            return manager
        }
        if allowNil {
            return nil
        }else{
            let manager = EasyEventManagerUnspecial()
            self.managers[event] = manager
            return manager
        }
    }
    public func didUnregisterEventHandler(for event: EventType) {
        if let manager = self.managers[event] {
            ///当删掉所有的Handler后，把这个事件的管理器也删除
            if  manager.handlers.count == 0 {
                self.managers.removeValue(forKey: event)
            }
        }
    }
}
