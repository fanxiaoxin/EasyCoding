//
//  ExamplePrecondition.swift
//  EasyCoding_Example
//
//  Created by JY_NEW on 2020/7/11.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

class ExamplePrecondition: Precondition {
    var text: String? = "i'm text"
    override init() {
        super.init()
        print("i born")
    }
    deinit {
        print("i die")
    }
    override func check(completion: @escaping (Bool) -> Void) {
        print(self.text)
//        self.source?.view.showHUD()
        let api = ApiTest.Normal().asDataProvider().plugin(.loading(for: self.source!.view))
        api.easy.retain()
        api.easyData { [weak self, weak api] (result) in
            api?.easy.release()
            print(self?.text)
//            self?.source?.view.hideHUD()
            completion(true)
        }
    }
}
extension ECViewControllerCondition {
    static var example: ECViewControllerCondition {
        return ExamplePrecondition()
    }
}
