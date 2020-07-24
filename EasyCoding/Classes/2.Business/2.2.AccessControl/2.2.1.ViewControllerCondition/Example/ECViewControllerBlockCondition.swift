//
//  SimplePrecondition.swift
//  Alamofire
//
//  Created by Fanxx on 2019/7/26.
//

import UIKit

public class ECViewControllerBlockCondition: ECViewControllerCondition {
    let block: (UIViewController, @escaping (Bool)->Void) -> Void
    public init(_ block: @escaping (UIViewController, @escaping (Bool)->Void) -> Void) {
        self.block = block
        super.init()
    }
    public override func check(completion: @escaping (Bool) -> Void) {
        self.block(self.source ?? UIViewController.easy.current!, completion)
    }
}
extension ECViewControllerCondition {
    public static func check(_ block: @escaping (UIViewController, @escaping (Bool)->Void) -> Void) -> ECViewControllerBlockCondition {
        return ECViewControllerBlockCondition(block)
    }
}
