//
//  ViewControllerAccessCenter.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/6/4.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import UIKit

/*
open class ECViewControllerPrecondition: ECPrecondition<UIViewController, Any> {
    
}*/
public typealias ECViewControllerPrecondition = ECPrecondition<UIViewController, Any>

extension ECPrecondition where InputType: UIViewController {
    ///当前控制器
    public var currentController: UIViewController? {
        return self.input ?? UIViewController.easy.current
    }
}

open class ECViewControllerAccessCenter: ECAccessCenter<UIViewController, Any> {
    ///单例
    public static let shared = ECViewControllerAccessCenter()
    ///将构造函数私有化，仅限单例使用
    private override init() { }
}

extension EC.NamespaceImplement where Base: UIViewController {
    @discardableResult public func check<ConditionType:ECViewControllerPrecondition>(condition:ConditionType, pass:@escaping (Any?)->Void) -> ConditionType {
        return ECViewControllerAccessCenter.shared.check(condition: condition, input: self.base, pass: pass)
    }
}
