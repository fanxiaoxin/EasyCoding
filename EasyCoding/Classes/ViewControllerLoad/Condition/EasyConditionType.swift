//
//  EasyConditionType.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/22.
//

import UIKit

///条件判断
public protocol EasyConditionType: EasyExtension {
    associatedtype ResultType
    ///检查分支
    func check(completion: @escaping (ResultType)->Void)
}

///扩展多个前提可轮流判断
extension Array: EasyConditionType where Element: EasyConditionType, Element.ResultType: EasyBooleanType {
    ///验证，若全是成功的则返回nil，失败则返回ResultType
    public func check(completion: @escaping (Element.ResultType?)->Void) {
        if let first = self.first {
            var prqs = self
            first.check { (result) in
                if (result.isPositive) {
                    ///等检测完再移除，防止被提前释放
                    prqs.removeFirst()
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
