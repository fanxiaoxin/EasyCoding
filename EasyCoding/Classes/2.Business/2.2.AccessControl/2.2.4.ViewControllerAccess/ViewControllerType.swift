//
//  ViewControllerType.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/11/23.
//

import UIKit

public protocol ECViewControllerType: UIViewController {
    ///进入场景，除非特殊情况由调用方设置，一般建议自己定义自己的场景或使用默认
    var segue: ECPresentSegue { get }
    ///设置进入该页面的权限
    var preconditions : [ECViewControllerPrecondition]? { get }
}
