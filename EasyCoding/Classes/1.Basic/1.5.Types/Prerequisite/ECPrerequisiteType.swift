//
//  ECPrerequisiteType.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/21.
//

import Foundation

///前提条件判断结果
public enum ECPrerequisiteResult<RejectInfoType> {
    ///通过
    case pass
    ///拒绝，返回拒绝相关信息
    case reject(RejectInfoType)
}
///前提
public protocol ECPrerequisiteType {
    associatedtype RejectInfoType
    ///验证
    func verify(completino: @escaping (ECPrerequisiteResult<RejectInfoType>)->Void)
}
///扩展多个前提可轮流判断
extension Array where Element: ECPrerequisiteType {
    ///验证
    public func verify(completion: @escaping (ECPrerequisiteResult<Element.RejectInfoType>)->Void) {
        if self.count > 0 {
            var prqs = self
            let first = prqs.removeFirst()
            first.verify { (result) in
                switch result {
                case .pass: prqs.verify(completion: completion)
                case .reject(_): completion(result)
                }
            }
        }else{
            completion(.pass)
        }
    }
}
