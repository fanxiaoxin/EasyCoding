//
//  ECApiDataPluginDecorator.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/13.
//

import UIKit
import HandyJSON
import Moya
import Result
//
//open class ECApiDecorator<ApiType: ECResponseApiType>: ECResponseApiType {
//    public typealias ResponseType = ApiType.ResponseType
//    
//    public let targetApi: ApiType
//    
//    open var manager: ECApiManagerType? = .none
//    open var callbackQueue: DispatchQueue? = .none
//    open var progress: ProgressBlock? = .none
//    
//    
//    
//    public init(api: ApiType) {
//        self.targetApi = api
//    }
//    ///文件下载本地路径
//    public var destinationURL: URL?
//    /// The target's base `URL`.
//    public var baseURL: URL { return self.targetApi.baseURL }
//    
//    /// The path to be appended to `baseURL` to form the full `URL`.
//    public var path: String {  return self.targetApi.path }
//    
//    /// The HTTP method used in the request.
//    public var method: Moya.Method {  return self.targetApi.method }
//    
//    /// Provides stub data for use in testing.
//    public var sampleData: Data {  return self.targetApi.sampleData }
//    
//    /// The type of HTTP task to be performed.
//    public var task: Task {
//        let task = self.targetApi.task
//        switch task {
//        case let .downloadDestination(destination):
//            return .downloadDestination { [weak self](temp, response) -> (destinationURL: URL, options: DownloadRequest.DownloadOptions) in
//                let result = destination(temp, response)
//                self?.destinationURL = result.destinationURL
//                return result
//            }
//        case let .downloadParameters(parameters: parameters, encoding: encoding, destination: destination):
//            return .downloadParameters(parameters: parameters, encoding: encoding) { [weak self](temp, response) -> (destinationURL: URL, options: DownloadRequest.DownloadOptions) in
//                let result = destination(temp, response)
//                self?.destinationURL = result.destinationURL
//                return result
//            }
//        default:
//            return task
//        }
//    }
//    
//    /// The type of validation to perform on the request. Default is `.none`.
//    public var validationType: ValidationType {  return self.targetApi.validationType }
//    
//    /// The headers to be used in the request.
//    public var headers: [String: String]? {  return self.targetApi.headers }
//    public var parameters: [String: Any]? { return self.targetApi.parameters }
//       ///是否将参数放于Body中否则放URL，默认GET放URL，其他放Body
//    public var isBodyParamters: Bool { return self.targetApi.isBodyParamters }
//}
//extension ECApiDecorator: ECDownloadApiType where ApiType: ECDownloadApiType {
//    
//}

///Api数据插件装饰器
open class ECApiDataPluginDecorator<ApiType: ECResponseApiType>: ECDataPluginDecorator<ApiType> {
    deinit {
        print("i die")
    }
    open var manager: ECApiManagerType? = .none
    open var callbackQueue: DispatchQueue? = .none
    open var progress: ProgressBlock? = .none
    
    open func request(original completion:@escaping (Result<DataType, Error>) -> Void, injected injectedCompletion: @escaping (Result<DataType, Error>) -> Void) {
        if let api = self.dataProvider {
            (self.manager ?? api.manager).request(api, callbackQueue: self.callbackQueue, progress: self.progress) { (result) in
                self.doNothing()
                switch result {
                case let .success(response): injectedCompletion(.success(response))
                case let .failure(error): injectedCompletion(.failure(error))
                }
            }
        }
    }
    func doNothing() {
        print("do nothing")
    }
}
extension ECResponseApiType {
    ///提供简短的类型声明，解决泛型使用时声明太长的问题
    public typealias DataPlugin = ECApiDataPluginDecorator<Self>
    ///添加插件
    public func dataPlugin(manager: ECApiManagerType? = .none,callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none, _ plugins: ECDataPlugin<ResponseType>...) -> DataPlugin {
        let decorator = ECApiDataPluginDecorator<Self>()
        decorator.manager = manager
        decorator.callbackQueue = callbackQueue
        decorator.progress = progress
        decorator.plugins = plugins
        decorator.dataProvider = self
        return decorator
    }
}
