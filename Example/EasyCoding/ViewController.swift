//
//  ViewController.swift
//  EasyCoding
//
//  Created by fanxiaoxin_1987@126.com on 06/02/2020.
//  Copyright (c) 2020 fanxiaoxin_1987@126.com. All rights reserved.
//

import UIKit
import EasyCoding
//import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        self.view.easy.add(.build({ (view) in
//            view.add(UILabel.easy(.center), layout: .top, .left(3))
//        }), layout: .right(30))
        
        let views = [UIView.easy(.bg(.red), .height(10, .required)),
                     UIButton.easy(.bg(.blue), .height(20, .low), .event(self, #selector(self.test))),
                     UIView.easy(.bg(.green), .height(20, .low))]
        let stack = UIStackView()
        self.view.easy.style(.bg(.lightGray)).add(stack.easy(.views(views),
                                      .axis(.vertical), .alignment(.fill), .distribution(.fillProportionally)), layout: .margin(50))
        
        
//        let view = UIView.easy(.bg(.yellow), .height(5))
//            stack.addSubview(view)
//        view.snp.makeConstraints { (make) in
//            make.left.right.equalTo(stack)
//            make.centerY.equalTo(views[0].snp.bottom)
//            make.centerY.equalTo(views[1].snp.top)
//        }
    }
    @objc func test() {
        let label = UILabel.easy(.text("这是一优话哈哈哈哈呈"), .font(size: 13), .color(.blue))
        let config = ECAlertConfig()
        config.background.style(.bg(.yellow))
        config.button(for: .destructive).style(.bg(.lightGray))
        let alert = ECAlertController(title: "看看我的标题", contentView: label, buttons: [ECAlertController.Button(type: .positive,text: "不确定", action: { _ in
            print("FUCK")
        }), ECAlertController.Button(type: .destructive,text: "关了我吧", action: { alert in
                alert.dismiss()
        })], config: nil)
        alert.title = "我是标题"
        alert.show()
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
