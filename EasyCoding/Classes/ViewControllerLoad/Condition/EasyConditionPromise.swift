//
//  EasyConditionPromise.swift
//  EasyComponents
//
//  Created by 范晓鑫 on 2021/2/18.
//
#if canImport(PromiseKit)

import EasyCoding
import PromiseKit

// MARK: Condition
public extension EasyConditionType {
    func promise() -> Guarantee<ResultType> {
        return Guarantee { (seal) in
            self.check(completion: seal)
        }
    }
}
public extension EasyConditionType where Self: AnyObject {
    func promise() -> Guarantee<ResultType> {
        return Guarantee { [weak self] (seal) in
            self?.check(completion: seal)
        }
    }
}
#endif
