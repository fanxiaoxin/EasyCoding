//
//  Data.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/23.
//

import UIKit

///抽象数据提供接口，可给需要数据的控件提供定制
public protocol ECDataProviderType {
    ///所提供的数据类型
    associatedtype DataType
    ///请求数据
    func easyData(completion: @escaping (DataType?, Error?) -> Void)
}
extension ECDataProviderType {
    ///请求数据，无视错误操作
    public func easyData(completion: @escaping (DataType) -> Void) {
        self.easyData { (data, error) in
            if let d = data, error == nil {
                completion(d)
            }
        }
    }
}
///静态数据
public protocol ECDataType: ECDataProviderType where DataType == Self {
    
}
extension ECDataType {
    public typealias DataType = Self
    ///请求数据
    public func easyData(completion: (DataType?, Error?) -> Void) {
        completion(self, nil)
    }
}

//常见的基础类型均可作为数据源
extension NSObject: ECDataType { }
extension Dictionary: ECDataType { }
extension Array: ECDataType { }
extension URL: ECDataType { }
extension String: ECDataType { }
extension Int: ECDataType { }
extension Int8: ECDataType { }
extension Int16: ECDataType { }
extension Int32: ECDataType { }
extension Int64: ECDataType { }
extension Float: ECDataType { }
extension Double: ECDataType { }
extension Float80: ECDataType { }
extension Date: ECDataType { }
extension Data: ECDataType { }
