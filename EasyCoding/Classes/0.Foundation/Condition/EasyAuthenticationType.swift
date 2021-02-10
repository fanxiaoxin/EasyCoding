//
//  EasyAuthenticationType.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/24.
//

import UIKit

///鉴权类型，返回值只有成功失败，该协议用于声明
public protocol EasyAuthenticationDefineType {
    ///检查分支
    func check(completion: @escaping (Bool)->Void)
}
///鉴权类型，返回值只有成功失败，该协议用于继承 
public protocol EasyAuthenticationType: EasyAuthenticationDefineType, EasyConditionType where ResultType == Bool {
    
}
