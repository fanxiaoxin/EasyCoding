//
//  TextConstraintController.swift
//  EasyCoding_Example
//
//  Created by JY_NEW on 2020/7/8.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import EasyCoding

class TextConstraintController: ECViewController<TextConstraintView> {
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
}
class TextConstraintView: ECPage {
    let textField = UITextField()
    let textField2 = UITextField()
    
    
    override func load() {
        self.easy.style(.bg(.white)).add(textField.easy(.border(.systemBlue), .constraint(.picker(provider: ["A","B","C"]))), layout: .top(30), .marginX(20), .height(30))
            .next(textField2.easy(.border(.systemRed), .constraint(.picker(providers: PickerViewDataSourceController.Provider(), PickerViewDataSourceController.Provider(), text: { $0.0 + "-" + $0.1}))), layout: .bottomTop(25), .marginX, .height(30))
    }
}
