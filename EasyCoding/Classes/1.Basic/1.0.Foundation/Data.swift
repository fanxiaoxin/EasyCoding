//
//  Data.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/23.
//

import UIKit

// MARK:  -最基本抽象数据提供接口，不区分同异步: ECDataProviderType

///抽象数据提供接口，可给需要数据的控件提供定制
public protocol ECDataProviderType {
    ///所提供的数据类型
    associatedtype DataType
    ///请求数据
    /// * completion    请求完成操作
    func easyData(completion: @escaping (Result<DataType, Error>) -> Void)
}
extension ECDataProviderType {
    ///请求数据，无视错误操作
    public func easyDataWithoutError(completion: @escaping (DataType) -> Void) {
        self.easyData { result in
            switch result {
            case let .success(data): completion(data)
            default: break
            }
        }
    }
}

// MARK:  -静态数据协议: ECDataType

///静态数据
public protocol ECDataType: ECDataProviderType where DataType == Self {
    
}
extension ECDataType {
    public typealias DataType = Self
    ///请求数据
    public func easyData(completion: @escaping (Result<DataType, Error>) -> Void) {
        completion(.success(self))
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

// MARK:  -静态数据异常协议: ECDataErrorType

///静态数据异常
public protocol ECDataErrorType: Error, ECDataProviderType {
    
}
extension ECDataErrorType {
    ///请求数据
    public func easyData(completion: @escaping (Result<DataType, Error>) -> Void) {
        completion(.failure(self))
    }
}
// MARK:  -通用静态数据异常类: ECDataError

///静态数据异常类
public struct ECDataError<DataType>: ECDataErrorType {
    ///异常编码
    public let code: Int
    ///异常信息
    public let message: String
    ///数据异常
    /// * code   异常编码
    /// * message   异常信息
    public init(code: Int = -1,_ message: String) {
        self.code = code
        self.message = message
    }
}
extension ECDataError: CustomStringConvertible {
    public var description: String {
        return self.message
    }
}

// MARK: -可注入操作的协议: ECDataProviderInjectable

///提供数据请求过程中的可注入方法
public protocol ECDataProviderInjectable: ECDataProviderType {
    ///即将请求数据，可中断
    func willRequest() -> Bool
    ///请求数据结束
    func didRequest()
    ///即将响应，可中断
    func willResponse(for result: Result<DataType, Error>, completion: @escaping (Result<DataType, Error>) -> Void) -> Bool
    ///响应结束
    func didResponse(for result: Result<DataType, Error>, completion: @escaping (Result<DataType, Error>) -> Void)
}
extension ECDataProviderInjectable {
    ///即将请求数据，可中断
    public func willRequest() -> Bool { return true }
    ///请求数据结束
    public func didRequest() {}
    ///即将响应，可中断
    public func willResponse(for result: Result<DataType, Error>, completion: @escaping (Result<DataType, Error>) -> Void) -> Bool { return true }
    ///响应结束
    public func didResponse(for result: Result<DataType, Error>, completion: @escaping (Result<DataType, Error>) -> Void) {}
}

// MARK: -装饰器模式协议: ECDataProviderDecoratorType

///装饰器模式，可继承该协议实现请求数据的过程中插入各种操作，如添加空数据页、请求错误页、请求加载Loading动画、请求日志等操作
public protocol ECDataProviderDecoratorType: class, ECDataProviderInjectable {
    associatedtype DataProviderType: ECDataProviderType
    ///需要装饰的数据类型
    var dataProvider : DataProviderType? { get set }
}
///默认添加注入，本想限制该协议只能使用在DataType相等的情况，但编译器一直无法通过，只能这样实现
extension ECDataProviderDecoratorType where DataProviderType.DataType == DataType {
    public func easyData(completion: @escaping (Result<DataType, Error>) -> Void) {
        if self.willRequest() {
            self.dataProvider?.easyData { [weak self] (result) in
                if self?.willResponse(for: result, completion: completion) ?? false {
                    completion(result)
                    self?.didResponse(for: result, completion: completion)
                }
            }
            self.didRequest()
        }
    }
}
