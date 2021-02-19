//
//  EventTriggerable.swift
//  Alamofire
//
//  Created by Fanxx on 2019/6/12.
//

import UIKit
public protocol EasyEventTriggerable: EasyEventPublisherType where EventType: Hashable {
    var event: EasyEventPublisher<EventType> { get }
}
extension EasyEventTriggerable  {
   ///根据事件获取管理器
    public func manager(for event:EventType, allowNil:Bool) -> EasyEventManagerUnspecialType? {
        return self.event.manager(for: event, allowNil: allowNil)
    }
    ///当删除处理时发送一个通知public 
    public func didUnregisterEventHandler(for event:EventType) {
        self.event.didUnregisterEventHandler(for: event)
    }
}

extension EasyEventTriggerable where Self: NSObject {
    public var event: EasyEventPublisher<EventType> {
        return self.easy.bindAssociatedObject("ec_event_publisher", creation: { EasyEventPublisher<EventType>() })
    }
}
