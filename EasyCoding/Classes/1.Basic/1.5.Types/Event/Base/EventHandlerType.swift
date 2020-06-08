//
//  EventHandler.swift
//  EasyCoding
//
//  Created by Fanxx on 2018/3/28.
//  Copyright © 2018年 fanxx. All rights reserved.
//

import Foundation

public protocol ECEventHandlerBaseType {
    ///执行事件
    func execute(_ event:Any)
}
public protocol ECEventHandlerType: Equatable, ECEventHandlerBaseType {
    ///事件类型
    associatedtype EventType: ECEventType
    ///执行事件
    func execute(_ event:EventType)
}
extension ECEventHandlerType {
    public func execute(_ event:Any) {
        if let e = event as? EventType {
            self.execute(e)
        }
    }
}

extension ECEventHandlerType where EventType == ECNull {
    public func execute() {
        self.execute(.null)
    }
}
