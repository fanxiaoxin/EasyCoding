//
//  ViewControllerType.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/11/23.
//

import UIKit

public protocol EasyViewControllerType: UIViewController {
    ///进入场景，除非特殊情况由调用方设置，一般建议自己定义自己的场景或使用默认
    var segue: EasyPresentSegue { get }
    ///设置进入该页面的权限
    var preconditions : [EasyViewControllerCondition]? { get }
}
extension EasyViewControllerType {
    ///进入场景，除非特殊情况由调用方设置，一般建议自己定义自己的场景或使用默认
    public var segue: EasyPresentSegue { return .pushOrPresent }
    ///设置进入该页面的权限
    public var preconditions : [EasyViewControllerCondition]? { return nil }
}

