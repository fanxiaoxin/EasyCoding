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
    
    ///注入专用的调用接口的方法
    /// * original completion    用户请求的操作
    /// * injected completion    被注入后的操作
    func easyData(original completion:@escaping (Result<DataType, Error>) -> Void, injected injectedCompletion: @escaping (Result<DataType, Error>) -> Void)
}
extension ECDataProviderType {
    ///注入专用的调用接口的方法
    /// * original completion    用户请求的操作
    /// * injected completion    被注入后的操作
    public func easyData(original completion:@escaping (Result<DataType, Error>) -> Void, injected injectedCompletion: @escaping (Result<DataType, Error>) -> Void) {
        self.easyData(completion: injectedCompletion)
    }
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

extension ECDataError: LocalizedError {
    public var errorDescription: String? {
        return self.message
    }

    public var failureReason: String? {
        return self.message
    }

    public var helpAnchor: String? {
        return self.message
    }

    public var recoverySuggestion: String? {
        return self.message
    }
}


// MARK: -可注入操作的协议: ECDataProviderInjectable

///提供数据请求过程中的可注入方法
public protocol ECDataProviderInjectable {
    ///所提供的数据类型
    associatedtype DataType
    ///即将请求数据，可中断
    func willRequest(for provider: Any) -> Bool
    ///请求数据结束
    func didRequest(for provider: Any)
    ///即将响应，可中断
    func willResponse(for provider: Any, result: Result<DataType, Error>, completion: @escaping (Result<DataType, Error>) -> Void) -> Result<DataType, Error>?
    ///响应结束
    func didResponse(for provider: Any, result: Result<DataType, Error>, completion: @escaping (Result<DataType, Error>) -> Void)
    ///设置最后一次原始请求操作，可用于重试，默认无视，需要则继承
    var lastCompletion: ((Result<DataType, Error>) -> Void)? { get set }
}
extension ECDataProviderInjectable {
    ///即将请求数据，可中断
    public func willRequest(for provider: Any) -> Bool { return true }
    ///请求数据结束
    public func didRequest(for provider: Any) {}
    ///即将响应，可中断
    public func willResponse(for provider: Any, result: Result<DataType, Error>, completion: @escaping (Result<DataType, Error>) -> Void) -> Result<DataType, Error>? { return result }
    ///响应结束
    public func didResponse(for provider: Any, result: Result<DataType, Error>, completion: @escaping (Result<DataType, Error>) -> Void) {}
    ///最后一次请求操作，默认无视
    public var lastCompletion: ((Result<DataType, Error>) -> Void)? {
        get{
            return nil
        }
        set{}
    }
}
extension ECDataProviderType {
}

// MARK: - 装饰器模式协议: ECDataProviderDecoratorType

///装饰器模式，可继承该协议实现请求数据的过程中插入各种操作，如添加空数据页、请求错误页、请求加载Loading动画、请求日志等操作
public protocol ECDataProviderDecoratorType: class, ECDataProviderInjectable, ECDataProviderType {
    associatedtype DataProviderType: ECDataProviderType
    ///需要装饰的数据类型
    var dataProvider : DataProviderType? { get set }
}
///默认添加注入，本想限制该协议只能使用在DataType相等的情况，但编译器一直无法通过，只能这样实现
extension ECDataProviderDecoratorType where DataProviderType.DataType == DataType {
    ///注入专用的调用接口的方法
    /// * original completion    用户请求的操作
    /// * injected completion    被注入后的操作
    public func easyData(original completion:@escaping (Result<DataType, Error>) -> Void, injected injectedCompletion: @escaping (Result<DataType, Error>) -> Void) {
        if let provider = self.dataProvider {
            if self.willRequest(for: provider) {
                self.dataProvider?.easyData(original: completion, injected: { [weak self] (result) in
                    if let s = self {
                        if let provider = s.dataProvider {
                            if let r = self?.willResponse(for: provider, result: result, completion: injectedCompletion) {
                                self?.lastCompletion = completion
                                injectedCompletion(r)
                                self?.didResponse(for: provider, result: r, completion: injectedCompletion)
                            }
                        }
                    }else{
                        injectedCompletion(result)
                    }
                })
                self.didRequest(for: provider)
            }
        }
    }
    public func easyData(completion: @escaping (Result<DataType, Error>) -> Void) {
        self.easyData(original: completion, injected: completion)
    }
    ///给装饰器内部调用，会自动将最后的completion传进去
    public func easyDataInject(completion: @escaping (Result<DataType, Error>) -> Void) {
        if let last = self.lastCompletion {
            self.easyData(original: last, injected: completion)
        }else{
            completion(.failure(ECDataError<DataType>("未主动调用过easyData")))
            if let provider = self.dataProvider {
                if self.willRequest(for: provider) {
                    self.didRequest(for: provider)
                    let result: Result<DataType, Error> = .failure(ECDataError<DataType>("未主动调用过easyData"))
                    if let r = self.willResponse(for: provider, result: result, completion: completion) {
                        completion(r)
                        self.didResponse(for: provider, result: r, completion: completion)
                    }
                }
            }
        }
    }
}

// MARK: - (废弃，改为使用ECDataPluginDecorator)不特定类型装饰器类型: ECDataProviderGenericDecoratorType
/*
///通用的装饰器，不指定特定ECDataProviderType
public protocol ECDataProviderGenericDecoratorType: class, ECDataProviderInjectable, ECDataProviderType {
    ///缓存指定类型的获取数据方法，避免需要在类型里面加泛型特定类
    var dataProvider: ( (_ completion:@escaping (Result<DataType, Error>) -> Void,_ injectedCompletion: @escaping (Result<DataType, Error>) -> Void) -> Void)? { get set }
    ///设置数据提供器
    func set<DataProviderType: ECDataProviderType>(provider: DataProviderType) where DataProviderType.DataType == DataType
}
extension ECDataProviderGenericDecoratorType {
    ///注入专用的调用接口的方法
    /// * original completion    用户请求的操作
    /// * injected completion    被注入后的操作
    public func easyData(original completion:@escaping (Result<DataType, Error>) -> Void, injected injectedCompletion: @escaping (Result<DataType, Error>) -> Void) {
        if self.willRequest() {
            self.dataProvider?(completion, { [weak self] (result) in
                if let r = self?.willResponse(for: result, completion: injectedCompletion) {
                    self?.lastCompletion = completion
                    injectedCompletion(r)
                    self?.didResponse(for: r, completion: injectedCompletion)
                }
            })
            self.didRequest()
        }
    }
    public func easyData(completion: @escaping (Result<DataType, Error>) -> Void) {
        self.easyData(original: completion, injected: completion)
    }
    ///设置数据提供器
    public func set<DataProviderType: ECDataProviderType>(provider: DataProviderType) where DataProviderType.DataType == DataType {
        ///此处不用weak，可使provider被当前类持有
        self.dataProvider = provider.easyData
    }
}
*/
