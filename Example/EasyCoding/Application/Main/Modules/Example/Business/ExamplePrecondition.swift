//
//  ExamplePrecondition.swift
//  EasyCoding_Example
//
//  Created by JY_NEW on 2020/7/11.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

class ExamplePrecondition: Precondition {
    var text: String = "i'm text"
    override init() {
        super.init()
        print("i born")
    }
    deinit {
        print("i die")
    }
    override func check(completion: @escaping (Bool) -> Void) {
        print(self.text)
        let api = ApiTest.Normal()
        self.request(api) { [weak self] (response) in
            print(self?.text)
            completion(true)
        }
    }
}
extension ECViewControllerCondition {
    static var example: ECViewControllerCondition {
        return ExamplePrecondition()
    }
}
