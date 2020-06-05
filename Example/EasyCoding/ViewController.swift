//
//  ViewController.swift
//  EasyCoding
//
//  Created by fanxiaoxin_1987@126.com on 06/02/2020.
//  Copyright (c) 2020 fanxiaoxin_1987@126.com. All rights reserved.
//

import UIKit
import EasyCoding

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let a = "I'm".easy.attr(.color(.blue), .font(.systemFont(ofSize: 14)))
        let b: ECAttributedString = "i'm \("where \("ag", .color(.red)) ", .color(.blue)) here "
        let e = NSAttributedString.easy("I'm \("here\("fuck ", .color(.yellow))", .color(.red))  find me", .color(.blue))
        print(e)
//        let f:NSAttributedString =
//            .easy(.color(.blue), .font(size: 13)) {
//                "I'm "
//                    .easy(.color(.red)) {
//                    "hehe"
//                }
//                "haha"
//            }
        self.test("", "") {
            
        }
    }
    func test(_ attrs: String..., block: () -> Void) {
        
    }

}

class T4 {
    @ECProperty.Clamping(min: 1, max: 5)
    var test: Int = 4
    func callAsFunction(_ p: String?) -> String {
        return p ?? "FUCK"
    }
    func callAsFunction(_ p: String?, d: String) -> String {
        return p ?? "FUCK"
    }
    static func callAsFunction(_ p: Int) -> Int {
        return p
    }
}
///Swift5.1: Some 泛型
///Swift5.1: @propertyWrapper
///Swift5.1: @_functionBuilder
///Swift5.2: callAsFunction 把类当方法一样调用
