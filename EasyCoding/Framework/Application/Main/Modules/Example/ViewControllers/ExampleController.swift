//
//  ExampleController.swift
//  WTVideo
//
//  Created by JY_NEW on 2020/6/11.
//  Copyright © 2020 JunYue. All rights reserved.
//

import UIKit
import EasyCoding

class ExampleController: ViewController<ExamplePage> {
    ///要求通过ExamplePrecondition条件并且去调用 Exampler接口，若成功则打开
    override var preconditions: [ECViewControllerPrecondition]? {
        return [.example,
                .easy(action: { (condition, finished) in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        finished(true)
                    }
        })]
    }
    @objc var testName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(self.testName)
    }
}
class ExamplePage: Page {
    override func load() {
        self.title = "Example"
        self.easy.style(.bg(.red))
    }
}

