//
//  ECConditionType.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/22.
//

import UIKit

///条件判断
public protocol ECConditionType {
    associatedtype ResultType
    ///检查分支
    func check(completion: @escaping (ResultType)->Void)
}

///扩展多个前提可轮流判断
extension Array: ECConditionType where Element: ECConditionType, Element.ResultType: ECBooleanType {
    ///验证，若全是成功的则返回nil，失败则返回ResultType
    public func check(completion: @escaping (Element.ResultType?)->Void) {
        if self.count > 0 {
            var prqs = self
            let first = prqs.removeFirst()
            first.check { (result) in
                if (result.isPositive) {
                    prqs.check(completion: completion)
                }else{
                    completion(result)
                }
            }
        }else{
            completion(nil)
        }
    }
}
class BBB: ECConditionType {
    typealias ResultType = Bool
    func check(completion: @escaping (Bool) -> Void) {
        completion(true)
    }
}
class VVV {
    func xx() {
        let b = BBB()
        b.check { (haha) in
            
        }
        let c = [b, BBB()]
        c.check { (v) in
            
        }
        let r = [BBB].ResultType

    }
}
