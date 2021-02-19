//
//  Authority.swift
//  EasyCoding
//
//  Created by Fanxx on 2018/3/29.
//  Copyright © 2018年 fanxx. All rights reserved.
//

import Foundation

open class EasyViewControllerCondition: EasyAuthenticationType {
    public init() {
        
    }
    ///源ViewController
    open weak var source: UIViewController?
    
    open func check(completion: @escaping (Bool) -> Void) {
        completion(true)
    }
}
extension EasyCoding where Base: UIViewController {
    ///检查条件是否满足
    public func check(_ condition: EasyViewControllerCondition..., pass: @escaping () -> Void, reject: (() -> Void)?) {
        condition.forEach({ $0.source = self.base })
        condition.check { (result) in
            if result ?? true {
                pass()
            }else{
                reject?()
            }
        }
    }
}
