//
//  EasyInstantiateMediatorType.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/21.
//

import UIKit

///判断是否具体实例化的条件，及实例化方法的中介
public protocol EasyInstantiateConditionType: EasyEmptyInstantiable, EasyConditionType where ResultType: EasyBooleanType {
    ///实例类型
    associatedtype InstanceType
    ///实例化
    func instantiate() -> InstanceType
}
extension EasyInstantiateConditionType {
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
extension EasyInstantiateConditionType where InstanceType: EasyEmptyInstantiable {
    ///实例化
    public func instantiate() -> InstanceType {
        return InstanceType()
    }
}
extension EasyInstantiateConditionType where InstanceType == Self {
    ///实例化
    public func instantiate() -> InstanceType {
        return self
    }
}

///有条件的初始化
public protocol EasyConditionInstantiable {
    associatedtype ConditionType: EasyInstantiateConditionType where ConditionType.InstanceType == Self
}
extension EasyConditionInstantiable {
    ///获取实例
    public static func instantiate(success: @escaping (Self)->Void, failure:((ConditionType.ResultType) -> Void)? = nil) {
        ConditionType().instance(success: success, failure: failure)
    }
}
