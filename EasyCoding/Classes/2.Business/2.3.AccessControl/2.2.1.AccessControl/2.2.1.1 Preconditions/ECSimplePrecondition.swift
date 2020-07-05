//
//  SimplePrecondition.swift
//  Alamofire
//
//  Created by Fanxx on 2019/7/26.
//

import UIKit

public class ECSimplePrecondition<IT,OT>: ECPrecondition<IT,OT> {
    var verfiyAction: ((ECSimplePrecondition<IT,OT>, @escaping (Bool)->Void)->Void)? = nil
    public init(_ action: @escaping (ECSimplePrecondition<IT,OT>, @escaping (Bool)->Void)->Void) {
        super.init()
        self.verfiyAction = action
    }
    public override func verify() {
//        weak var weakSelf = self
        self.verfiyAction?(self, self.finished)
    }
}
extension ECPrecondition {
    public static func easy(action: @escaping (ECSimplePrecondition<InputType,OutputType>, @escaping (Bool)->Void)->Void) -> ECSimplePrecondition<InputType, OutputType> {
        return ECSimplePrecondition<InputType,OutputType>(action)
    }
}

/*
class ECViewControllerSimplePrecondition : ECViewControllerPrecondition {
    var verfiyAction: (((Bool)->Void)->Void)? = nil
    public init(_ action: @escaping ((Bool)->Void)->Void) {
        super.init()
        self.verfiyAction = action
    }
    public override func verify() {
        self.verfiyAction?(self.finished)
    }
}
extension ECViewControllerPrecondition {
    public static func simple(action: @escaping ((Bool)->Void)->Void) -> ECViewControllerPrecondition {
        return ECViewControllerSimplePrecondition(action)
    }
}
 */