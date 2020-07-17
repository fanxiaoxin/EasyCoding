//
//  ExamplePrecondition.swift
//  EasyCoding_Example
//
//  Created by JY_NEW on 2020/7/11.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

class ExamplePrecondition: Precondition {
    override func verify() {
        let isPass = true
        //判断是否通过
        self.finished(isPass)
    }
    override func failureAction() {
        //失败处理，比如弹出失败页面
//        if let current = self.currentViewController {
//            let failureController = FailureController()
//            current.load(failureController)
//        }
        super.failureAction()
    }
}
extension ECViewControllerPrecondition {
    static var example: ECViewControllerPrecondition {
        return ExamplePrecondition()
    }
}
