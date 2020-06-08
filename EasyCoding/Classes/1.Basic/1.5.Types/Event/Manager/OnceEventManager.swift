//
//  OnceEvent.swift
//  EasyCoding
//
//  Created by Fanxx on 2018/3/28.
//  Copyright © 2018年 fanxx. All rights reserved.
//

import Foundation

///只触发一次的事件，触发后马上移除所有的handler
open class ECOnceEventManager<EventType: ECEventType>: ECEventManager<EventType> {
    ///若已触发事件，则不为nil，若未触发则为nil，当不为nil时每次新添加事件处理都马上触发并移除，每次调用fire方法后(若被中断则丢弃后续处理)该值不为nil，若不想后续即时触发需调用reset()
    public var firedEvent: EventType?
    
    open override func add<HandlerType>(handler: HandlerType) where EventType == HandlerType.EventType, HandlerType : ECEventHandlerType {
        if let event = self.firedEvent {
            handler.execute(event)
        }else{
            super.add(handler: handler)
        }
    }
    open override func fire(for event: EventType) {
        self.firedEvent = event

        while self.handlers.count > 0 {
            self.handlers.removeFirst().execute(event)
            if self.isAborting {
                self.handlers.removeAll()
                self.isAborting = false
                break
            }
        }
    }
    ///重置为未触发状态
    open func reset() {
        self.firedEvent = nil
    }
}

public typealias ECOnceEvent = ECOnceEventManager<ECNull>
