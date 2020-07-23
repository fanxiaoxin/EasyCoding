//
//  ECInstantiateMediatorType.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/21.
//

import UIKit

///判断是否具体实例化的条件，及实例化方法的中介
public protocol ECInstantiateConditionType: ECEmptyInstantiable, ECConditionType where ResultType: ECBooleanType {
    ///实例类型
    associatedtype InstanceType
    ///实例化
    func instantiate() -> InstanceType
}
extension ECInstantiateConditionType {
    ///获取实例
    public func instance(success: @escaping (InstanceType)->Void, failure:((ResultType) -> Void)? = nil) {
        let instantiate = self.instantiate
        self.check { (result) in
            if result.passed {
                success(instantiate())
            }else{
                failure?(result)
            }
        }
    }
}
extension ECInstantiateConditionType where InstanceType: ECEmptyInstantiable {
    ///实例化
    public func instantiate() -> InstanceType {
        return InstanceType()
    }
}
extension ECInstantiateConditionType where InstanceType == Self {
    ///实例化
    public func instantiate() -> InstanceType {
        return self
    }
}

///有条件的初始化
public protocol ECConditionInstantiable {
    associatedtype ConditionType: ECInstantiateConditionType where ConditionType.InstanceType == Self
}
extension ECConditionInstantiable {
    ///获取实例
    public static func instantiate(success: @escaping (Self)->Void, failure:((ConditionType.ResultType) -> Void)? = nil) {
        ConditionType().instance(success: success, failure: failure)
    }
}
