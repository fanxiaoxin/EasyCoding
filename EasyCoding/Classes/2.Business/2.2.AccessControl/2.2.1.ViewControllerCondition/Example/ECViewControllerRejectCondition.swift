//
//  RejectTypePrecondition.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/11/5.
//

import UIKit

open class ECViewControllerRejectCondition: ECViewControllerCondition {
    public let types: [AnyClass]
    public init(types: [AnyClass]) {
        self.types = types
        super.init()
    }
    open override func check(completion: @escaping (Bool) -> Void) {
        if let controller = self.source {
            if self.types.contains(where: { controller.isKind(of: $0) }) {
                return completion(false)
            }
        }
        completion(true)
    }
}

extension ECViewControllerRejectCondition {
    public static func reject(_ types: AnyClass...) -> ECViewControllerRejectCondition {
        return ECViewControllerRejectCondition(types: types)
    }
}
