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
        
    }
    @objc func onClick() {
        print("点击了按钮")
    }
}
