//
//  ECInstantiateMediatorType.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/21.
//

import UIKit

///判断是否具体实例化的条件，及实例化方法的中介
public protocol ECInstantiateMediatorType {
    ///实例化前提
    associatedtype PrerequisiteType: ECPrerequisiteType
    ///实例类型
    associatedtype InstanceType
    ///前提
    var prerequisites: [PrerequisiteType] { get }
    ///实例化
    func instantiate() -> InstanceType
}
extension ECInstantiateMediatorType {
    ///获取实例
    public func instance(success: @escaping (InstanceType)->Void, failure:((PrerequisiteType.RejectInfoType) -> Void)? = nil) {
        let instantiate = self.instantiate
        self.prerequisites.verify { (result) in
            switch result {
            case .pass: success(instantiate())
            case let .reject(info): failure?(info)
            }
        }
    }
}
extension ECInstantiateMediatorType where InstanceType == Self {
    ///实例化
    public func instantiate() -> InstanceType {
        return self
    }
}
