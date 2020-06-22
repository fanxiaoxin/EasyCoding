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
        
        let views = [UIView.easy(.bg(.red)),
                     UIView.easy(.bg(.blue), .tap(self, #selector(self.test))),
                     UIView.easy(.bg(.green)),
                     UILabel.easy(.attr("我是一段富文本，要问我有多\("富234234234", .boldFont(size: 20), .color(.blue)),我也不知道"), .color(.yellow),.font(size: 15), .bg(.lightGray), .lines())]
        
        views[0].easy.layout(.priority(.height(10), .low))
        views[1].easy.layout(.priority(.height(20), .low))
        views[2].easy.layout(.priority(.height(30), .low))
        views[3].easy.layout(.priority(.height(30), .low))
        
        let stack = UIStackView()
        self.view.easy.style(.bg(.init(white: 0.9, alpha: 1))).add(stack.easy(.views(views),
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
        //        ECAlertConfig.default.message.addStyle(.boldFont(size: 20))
        //        ECAlertConfig.default.input.addStyle(.bg(.green))
        //        ECAlertConfig.default.input.layout(.margin(180, 0, 150, 0))
        ECMessageBox.confirm(title: "看这个标题", attr: "try metry \("trye3 ry metrry metr", .color(.red), .boldFont(size: 24)) metry metry metry me") { ECMessageBox.input(title: "来点东西", placeHolder: "随便输点") { (input) in
                ECMessageBox.toast(input.text ?? "没东西啊没东西啊没东西啊没没东西啊")
        }.easy(.constraint(.date(mode: .time, format: "HH:mm")))
        }
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
