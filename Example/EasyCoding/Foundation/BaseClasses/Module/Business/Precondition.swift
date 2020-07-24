//
//  Precondition.swift
//  YCP
//
//  Created by Fanxx on 2019/7/31.
//  Copyright © 2019 Ycp. All rights reserved.
//

import UIKit
import EasyCoding
import Moya

///页面加载条件类基类
class Precondition: ECViewControllerCondition {
    
}
extension UIViewController {
    public func check(condition:ECViewControllerCondition, pass:@escaping ()->Void) {
        return self.easy.check(condition, pass: pass, reject: nil)
    }
}
