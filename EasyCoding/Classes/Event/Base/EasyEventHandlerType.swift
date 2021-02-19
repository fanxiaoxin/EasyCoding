//
//  EventHandler.swift
//  EasyCoding
//
//  Created by Fanxx on 2018/3/28.
//  Copyright © 2018年 fanxx. All rights reserved.
//

import Foundation

public protocol EasyEventHandlerType {
    ///执行事件
    func execute(_ param:Any)
}
extension EasyEventHandlerType {
    public func execute() {
        self.execute(easyNull)
    }
}
