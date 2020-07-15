//
//  ECApiManager.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/14.
//

import UIKit
import Moya
import Alamofire

//负责Api整体相关管理工作
public protocol ECApiManagerType {
    ///格式化请求参数，可附加通用参数等操作
    func format(paramaters: [String: Any]?) -> [String:Any]?
    ///生成MoyaProvider
    func provider<ApiType: ECApiType>(for api: ApiType) -> MoyaProvider<ApiType>
    ///普通请求
    func request<ApiType: ECResponseApiType>(_ api: ApiType,callbackQueue: DispatchQueue?, progress: ProgressBlock?, completion: @escaping (Swift.Result<ApiType.ResponseType, Error>) -> Void)
    ///上传
    func request<ApiType: ECUploadApiType>(_ api: ApiType,callbackQueue: DispatchQueue?, progress: ProgressBlock?, completion: @escaping (Swift.Result<ApiType.ResponseType, Error>) -> Void)
    ///下载
    func request<ApiType: ECDownloadApiType>(_ api: ApiType,callbackQueue: DispatchQueue?, progress: ProgressBlock?, completion: @escaping (Swift.Result<ApiType.ResponseType, Error>) -> Void)
}

fileprivate func mappingError(_ info:String) -> Error {
    return NSError(domain: "ECApiManager", code: 999, userInfo: [NSLocalizedDescriptionKey: info])
}

// MARK: 下载套用的对象
fileprivate class ECDownloadApiTargetWapper<ApiType: ECDownloadApiType>: ECApiType {
    required init() {
        fatalError("不可用")
    }
    
    let targetApi: ApiType
    internal init(api: ApiType) {
        self.targetApi = api
    }
    ///文件下载本地路径
    internal var destinationURL: URL?
    /// The target's base `URL`.
    internal var baseURL: URL { return self.targetApi.baseURL }
    
    /// The path to be appended to `baseURL` to form the full `URL`.
    internal var path: String {  return self.targetApi.path }
    
    /// The HTTP method used in the request.
    internal var method: Moya.Method {  return self.targetApi.method }
    
    /// Provides stub data for use in testing.
    internal var sampleData: Data {  return self.targetApi.sampleData }
    
    /// The type of HTTP task to be performed.
    internal var task: Task {
        let task = self.targetApi.task
        switch task {
        case let .downloadDestination(destination):
            return .downloadDestination { [weak self](temp, response) -> (destinationURL: URL, options: DownloadRequest.DownloadOptions) in
                let result = destination(temp, response)
                self?.destinationURL = result.destinationURL
                return result
            }
        case let .downloadParameters(parameters: parameters, encoding: encoding, destination: destination):
            return .downloadParameters(parameters: parameters, encoding: encoding) { [weak self](temp, response) -> (destinationURL: URL, options: DownloadRequest.DownloadOptions) in
                let result = destination(temp, response)
                self?.destinationURL = result.destinationURL
                return result
            }
        default:
            return task
        }
    }
    
    /// The type of validation to perform on the request. Default is `.none`.
    public   var validationType: ValidationType {  return self.targetApi.validationType }
    
    /// The headers to be used in the request.
    public  var headers: [String: String]? {  return self.targetApi.headers }
}

extension ECApiManagerType {
    ///格式化请求参数，可附加通用参数等操作
    public func format(paramaters: [String: Any]?) -> [String:Any]? {
        return paramaters
    }
    ///生成MoyaProvider
    public func provider<ApiType: ECApiType>(for api: ApiType) -> MoyaProvider<ApiType> {
        return MoyaProvider<ApiType>()
    }
    public func onCompletionSuccess<ApiType: ECResponseApiType>(plugins: [PluginType],api: ApiType ,response: ApiType.ResponseType, completion:(Swift.Result<ApiType.ResponseType, Error>) -> Void) {
        let ecPlugins = plugins.compactMap({ $0 as? ECApiPluginType })
        ecPlugins.forEach({ $0.willReceive(response, target: api) })
        completion(.success(response))
        ecPlugins.forEach({ $0.didReceive(response, target: api) })
    }
    // MARK: 普通请求
    public func request<ApiType: ECResponseApiType>(_ api: ApiType,callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none, completion: @escaping (Swift.Result<ApiType.ResponseType, Error>) -> Void) {
        let provider = self.provider(for: api)
        provider.request(api, callbackQueue: callbackQueue, progress: progress) { (result) in
            switch result {
            case let .success(response):
                do {
                    if let json = try response.mapJSON() as? NSDictionary,
                        let s = ApiType.ResponseType.deserialize(from: json){
                        if let error = s.error {
                            completion(.failure(error))
                        }else{
                            self.onCompletionSuccess(plugins: provider.plugins, api: api, response: s, completion: completion)
                        }
                    }else{
                        let err = MoyaError.underlying(mappingError("Api结构化失败"), response)
                        completion(.failure(err))
                    }
                }catch(let error) {
                    let err = MoyaError.underlying(error, response)
                    completion(.failure(err))
                }
            case let .failure(error): completion(.failure(error))
            }
        }
    }
    // MARK: 上传
    public func request<ApiType: ECUploadApiType>(_ api: ApiType,callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none, completion: @escaping (Swift.Result<ApiType.ResponseType, Error>) -> Void) {
        let provider = self.provider(for: api)
        provider.request(api, callbackQueue: callbackQueue, progress: progress) { (result) in
            switch result {
            case .success(_):
                self.onCompletionSuccess(plugins: provider.plugins, api: api, response: .null, completion: completion)
            case let .failure(error): completion(.failure(error))
            }
        }
    }
    // MARK: 下载
    public func request<ApiType: ECDownloadApiType>(_ api: ApiType,callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none, completion: @escaping (Swift.Result<ApiType.ResponseType, Error>) -> Void) {
        let target = ECDownloadApiTargetWapper<ApiType>(api: api)
        let provider = self.provider(for: target)
        provider.request(target, callbackQueue: callbackQueue, progress: progress) { (result) in
            switch result {
            case .success(_):
                if let url = target.destinationURL {
                    self.onCompletionSuccess(plugins: provider.plugins, api: api, response: url, completion: completion)
                }else{
                    completion(.failure(mappingError("文件保存地址为空")))
                }
            case let .failure(error): completion(.failure(error))
            }
        }
    }
    // MARK: 不包含错误处理
    public func requestWithoutError<ApiType: ECResponseApiType>(_ api: ApiType, callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none, completion: @escaping (ApiType.ResponseType) -> Void) {
        self.request(api, callbackQueue: callbackQueue, progress: progress) { result in
            switch result {
            case let .success(data): completion(data)
            default: break
            }
        }
    }
}

///默认的ApiManager
public struct ECApiManager: ECApiManagerType {
    
}
