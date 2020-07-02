//
//  PopupController.swift
//  EasyCoding_Example
//
//  Created by JY_NEW on 2020/7/2.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import EasyCoding

class PopupController: ECViewController<PopupView> {
    override var segue: ECPresentSegue {
        return .popup
    }
}
class PopupView: ECPage {
    let contentView = UIView()
    override func load() {
        self.easy.add(contentView.easy(.size(300, 400), .bg(.white)), layout: .center)
        .next(button("Close", .text("关闭"), .bg(.blue), .color(.white), .corner(4), .size(60, 44)), layout: .center)
    }
}
