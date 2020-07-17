//
//  ControllerFlow.swift
//  YCP
//
//  Created by Fanxx on 2019/8/5.
//  Copyright © 2019 Ycp. All rights reserved.
//

import UIKit
import EasyCoding

///界面调用顺序流基类，子类继承buildFlow在里面构建流程即可
class ControllerFlow: ECControllerFlow {
    init() {
        super.init()
        self.buildFlow()
    }
    func buildFlow() {
        
    }
}
extension UIViewController{
    ///开启页面调用流程
    func start(_ flow: ControllerFlow) {
        flow.controller = self
        flow.activate()
    }
}
