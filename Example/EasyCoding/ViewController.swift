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
        TEST().haha()
        let t  = T4()
        let a = t("ssv")
        let c = t("", d: "ab")
        let b = t.callAsFunction("3434")
        
        let t4 = T4()("haha")
        
        print(t.test)
        t.test = 8
        print(t.test)
        t.test = 0
        print(t.test)
        t.test = 3
        print(t.test)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
