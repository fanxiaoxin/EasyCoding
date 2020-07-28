//
//  EventHandler.swift
//  EasyCoding
//
//  Created by Fanxx on 2018/3/28.
//  Copyright © 2018年 fanxx. All rights reserved.
//

import Foundation

public protocol ECEventHandlerType {
    ///执行事件
    func execute(_ param:Any)
}
extension ECEventHandlerType {
    public func execute() {
        self.execute(ecNull)
    }
}
