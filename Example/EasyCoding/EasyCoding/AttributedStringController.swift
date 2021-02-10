//
//  AttributeStringController.swift
//  EasyCoding_Example
//
//  Created by 范晓鑫 on 2021/2/10.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit

class AttributeStringController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel.easy(
            .attr("我是一段富文本，写起来很方便，比如这个\("红色的小字", .color(.red), .font(size: 11))和这个\("绿色的大字", .color(.green), .boldFont(size: 20))。",
                .color(.blue), .font(size: 15)),
            .lines(), .center)
        self.view.easy.style(.bg(.white))
            .add(label, layout: .centerY, .marginX(20))
    }
}
