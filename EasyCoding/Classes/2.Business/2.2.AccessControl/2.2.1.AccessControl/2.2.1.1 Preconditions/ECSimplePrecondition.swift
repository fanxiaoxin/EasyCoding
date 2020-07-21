//
//  SimplePrecondition.swift
//  Alamofire
//
//  Created by Fanxx on 2019/7/26.
//

import UIKit

public class ECSimplePrecondition<IT,OT>: ECPrecondition<IT,OT> {
    var verfiyAction: ((ECSimplePrecondition<IT,OT>)->Void)? = nil
    public init(_ action: @escaping (ECSimplePrecondition<IT,OT>)->Void) {
        super.init()
        self.verfiyAction = action
    }
    public override func verify() {
        self.verfiyAction?(self)
    }
}
extension ECPrecondition {
    public static func easy(action: @escaping (ECSimplePrecondition<InputType,OutputType>)->Void) -> ECSimplePrecondition<InputType, OutputType> {
        return ECSimplePrecondition<InputType,OutputType>(action)
    }
}
