//
//  ViewBuilderController.swift
//  EasyCoding_Example
//
//  Created by 范晓鑫 on 2021/2/10.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit

class ViewBuildController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel.easy(.text("我是文本"), .font(size: 14), .center, .color(.red))
        let button = UIButton.easy(.text("我是按钮"), .boldFont(size: 12), .align(.left), .color(.blue), .bg(.yellow), .corner(4), .event(self, #selector(self.onClick)))
        
        self.view.easy.style(.bg(.white))
            .add(label, layout: .top(20), .marginX)
            .next(button, layout: .bottomTop(15))
            .parent(.left(30), .width(80), .height(40))
        
        self.view.easy.add(.easy({ (content) in
            content.style(.bg(.systemBlue), .corner(10))
                .add(.label(.text("标题"), .color(.white)), layout: .top(5), .centerX)
                .next(.label(.text("内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容"), .lines(),.color(.white)), layout: .bottomTop(10))
                .parent(.bottom(5), .marginX(15))
        }), layout: .centerY, .marginX(30))
        
//        self.view.easy.style(.bg(.white))
//            .build(
//                (label, [.top(20), .marginX]),
//                (button, [.bottomTop(15), .width(80), .height(40), .parent(.left(30))])
//            )
//            .build(
//                (.easy { (content) in
//                    content.style(.bg(.systemBlue), .corner(10))
//                        .build(
//                            (.label(.text("标题"), .color(.white)), [.top(5), .centerX]),
//                            (.label(.text("内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容"), .lines(),.color(.white)), [.bottomTop(10), .parent(.bottom(5)), .parent(.marginX(15))])
//                        )
//                }, [.centerY, .marginX(30)])
//            )
    }
    @objc func onClick() {
        print("点击了按钮")
//        self.view.easy.build {
//            (UIView(), layout: .top, .left, .right),
//            (UIView(), layout: .),
//            (UIView(), layout: ),
//            (UIView(), layout: ),
//        }
//        let v =  d(value: 4, sss: 5)
        
    }
    func fuck(completion: (String) -> Void) {
        
    }
}
//@dynamicCallable
@_functionBuilder
struct Await {
    func sss() {
        
    }
    func dynamicallyCall<ResultType>(withArguments args: [((ResultType) -> Void) -> Void]) -> Int {
        return 0
    }
    func dynamicallyCall(withKeywordArguments args: KeyValuePairs<String, Int>) -> Double{
        return 5
    }
}
//struct await {
//
//}
///代表一个异步操作
struct async<T> {
    func buildBlock(){
        
    }
}
