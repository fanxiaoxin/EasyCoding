//
//  EasyAccessControlType.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/24.
//

import UIKit

///访问控制类型
public protocol EasyAccessControlType: EasyConditionType {
    ///访问者类型
    associatedtype VisitorType
    ///被访问者类型
    associatedtype IntervieweeType
    
    ///访问者
    var visitor: VisitorType? { get set }
    ///被访问者
    var interviewee: IntervieweeType? { get set }
}
