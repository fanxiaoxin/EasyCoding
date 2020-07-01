//
//  ECDataErrorToastDecorator.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/30.
//

import UIKit

///请求失败时弹toast信息
open class ECDataErrorToastDecorator<DataType>: ECDataErrorDecoratorType {
    deinit {
        print(NSStringFromClass(Self.self) + "die")
    }
    public var error: Error?
    
    public var dataProvider: ((@escaping (Result<DataType, Error>) -> Void, @escaping (Result<DataType, Error>) -> Void) -> Void)?
    
    open func load() {
        if let message = self.error?.localizedDescription {
            ECMessageBox.toast(message)
        }
    }
    open func unload() {
        
    }
    
    public init() {
        
    }
}
