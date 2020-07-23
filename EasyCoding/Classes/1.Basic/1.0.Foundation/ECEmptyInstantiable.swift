//
//  ECEmptyInstantiable.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/22.
//

import UIKit

public protocol ECEmptyInstantiable {
    init()
}
extension NSObject: ECEmptyInstantiable {
    
}
