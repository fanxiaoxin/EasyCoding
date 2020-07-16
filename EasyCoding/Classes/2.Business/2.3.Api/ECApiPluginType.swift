//
//  ECApiPluginType.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/15.
//

import UIKit
import Moya
import Result

public protocol ECApiPluginType: PluginType {
    //只会接受ECResponseApiType, 其中responser的类型和ECResponseApiType的response一致
    func willReceive(_ response: Any, target: ECApiType)
    //只会接受ECResponseApiType, 其中responser的类型和ECResponseApiType的response一致
    func didReceive(_ response: Any, target: ECApiType)
}
extension ECApiPluginType {
    public func willReceive(_ response: Any, target: ECApiType) {}
    public func didReceive(_ response: Any, target: ECApiType) {}
}
