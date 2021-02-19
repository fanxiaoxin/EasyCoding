//
//  EasyApiPluginType.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/15.
//

import UIKit
import Moya
import Result

public protocol EasyApiPluginType: PluginType {
    //只会接受EasyResponseApiType, 其中responser的类型和EasyResponseApiType的response一致
    func willReceive(_ response: Any, target: EasyApiType)
    //只会接受EasyResponseApiType, 其中responser的类型和EasyResponseApiType的response一致
    func didReceive(_ response: Any, target: EasyApiType)
}
extension EasyApiPluginType {
    public func willReceive(_ response: Any, target: EasyApiType) {}
    public func didReceive(_ response: Any, target: EasyApiType) {}
}
