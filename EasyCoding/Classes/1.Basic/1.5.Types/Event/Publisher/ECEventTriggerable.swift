//
//  EventTriggerable.swift
//  Alamofire
//
//  Created by Fanxx on 2019/6/12.
//

import UIKit
public protocol ECEventTriggerable: ECEventPublisherType where EventType: Hashable {
    var event: ECEventPublisher<EventType> { get }
}
extension ECEventTriggerable  {
   ///根据事件获取管理器
    public func manager(for event:EventType, allowNil:Bool) -> ECEventManagerUnspecialType? {
        return self.event.manager(for: event, allowNil: allowNil)
    }
    ///当删除处理时发送一个通知public 
    public func didUnregisterEventHandler(for event:EventType) {
        self.event.didUnregisterEventHandler(for: event)
    }
}

extension ECEventTriggerable where Self: NSObject {
    public var event: ECEventPublisher<EventType> {
        return self.easy.bindAssociatedObject("ec_event_publisher", creation: { ECEventPublisher<EventType>() })
    }
}
