//
//  AccessControl.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/6/4.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import UIKit

///权限控制中心，主要用于缓存权限对象释放自动管理
open class ECAccessCenter<InputType,OutputType>: ECPreconditionDelegate {
    private var conditions : [ECPrecondition<InputType,OutputType>] = []
    ///在这里调用可以缓存对象不至于被清除，如果直接调用很可能在判断完成前对象会丢失
    @discardableResult
    open func check<ConditionType:ECPrecondition<InputType,OutputType>>(condition:ConditionType, input:InputType?, pass:@escaping (OutputType?)->Void) -> ConditionType {
        condition.delegate = self
        self.conditions.append(condition)
        weak var cd = condition
        condition.check(input) {
            pass(cd?.output)
        }
        return condition
    }
    open func ECPrecondition(_ precondition: Any, passed: Bool) {
        let pc = precondition as! ECPrecondition<InputType,OutputType>
        if let idx = self.conditions.firstIndex(where: { (condition) -> Bool in
            return condition === pc
        }) {
            self.conditions.remove(at: idx)
        }
    }
}
