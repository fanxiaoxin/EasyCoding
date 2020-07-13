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
class Precondition: ECViewControllerPrecondition, ECApiRequestable {
    
}
extension UIViewController {
    @discardableResult public func check<ConditionType:ECViewControllerPrecondition>(condition:ConditionType, pass:@escaping ()->Void) -> ConditionType {
        return self.easy.check(condition: condition, pass: { (_) in
            pass()
        })
    }
}
extension ECSimplePrecondition : ECApiRequestable {
    
}
