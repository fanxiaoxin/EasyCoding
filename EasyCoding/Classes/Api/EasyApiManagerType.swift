//
//  EasyApiManager.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/14.
//

import UIKit
import Moya
import Alamofire

//负责Api整体相关管理工作
public protocol EasyApiManagerType {
    ///格式化请求参数，可附加通用参数等操作
    func format(paramaters: [String: Any]?) -> [String:Any]?
    ///生成MoyaProvider
    func provider<ApiType: EasyApiType>(for api: ApiType) -> MoyaProvider<ApiType>
    ///一般请求
    func request<ApiType: EasyResponseApiType>(_ api: ApiType,callbackQueue: DispatchQueue?, progress: ProgressBlock?, completion: @escaping (Swift.Result<ApiType.ResponseType, Error>) -> Void)
    ///下载
    func request<ApiType: EasyDownloadApiType>(_ api: ApiType,callbackQueue: DispatchQueue?, progress: ProgressBlock?, completion: @escaping (Swift.Result<ApiType.ResponseType, Error>) -> Void)
    ///测试
    func request<ApiType: EasyApiTestType>(_ api: ApiType,callbackQueue: DispatchQueue?, progress: ProgressBlock?, completion: @escaping (Swift.Result<ApiType.ResponseType, Error>) -> Void)
}

// MARK: ApiManager默认实现辅

extension EasyApiManagerType {
    ///格式化请求参数，可附加通用参数等操作
    public func format(paramaters: [String: Any]?) -> [String:Any]? {
        return paramaters
    }
    ///生成MoyaProvider
    public func provider<ApiType: EasyApiType>(for api: ApiType) -> MoyaProvider<ApiType> {
        return MoyaProvider<ApiType>()
    }
    // MARK: 一般请求
    public func request<ApiType: EasyResponseApiType>(_ api: ApiType,callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none, completion: @escaping (Swift.Result<ApiType.ResponseType, Error>) -> Void) {
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
                            Self.onCompletionSuccess(plugins: provider.plugins, api: api, response: s, completion: completion)
                        }
                    }else{
                        let err = MoyaError.underlying(Self.mappingError("Api结构化失败"), response)
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
    // MARK: 下载
    public func request<ApiType: EasyDownloadApiType>(_ api: ApiType,callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none, completion: @escaping (Swift.Result<ApiType.ResponseType, Error>) -> Void) {
        let target = EasyDownloadApiTargetWapper<ApiType>(api: api)
        let provider = self.provider(for: target)
        provider.request(target, callbackQueue: callbackQueue, progress: progress) { (result) in
            switch result {
            case .success(_):
                if let url = target.destinationURL {
                    Self.onCompletionSuccess(plugins: provider.plugins, api: api, response: url, completion: completion)
                }else{
                    completion(.failure(Self.mappingError("文件保存地址为空")))
                }
            case let .failure(error): completion(.failure(error))
            }
        }
    }
    // MARK: 测试
    public func request<ApiType: EasyApiTestType>(_ api: ApiType,callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none, completion: @escaping (Swift.Result<ApiType.ResponseType, Error>) -> Void) {
        let normalProvider = self.provider(for: api)
        let provider = MoyaProvider<ApiType>(endpointClosure: normalProvider.endpointClosure, requestClosure: normalProvider.requestClosure, stubClosure: MoyaProvider.delayedStub(api.delayTime), callbackQueue: callbackQueue, manager: normalProvider.manager, plugins: normalProvider.plugins, trackInflights: normalProvider.trackInflights)
        provider.request(api, callbackQueue: callbackQueue, progress: progress) { (result) in
            switch result {
            case .success(_):
                let s = api.response
                if let error = s.error {
                    completion(.failure(error))
                }else{
                    Self.onCompletionSuccess(plugins: provider.plugins, api: api, response: s, completion: completion)
                }
            case let .failure(error): completion(.failure(error))
            }
        }
    }
    // MARK: 不包含错误处理
    public func requestWithoutError<ApiType: EasyResponseApiType>(_ api: ApiType, callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none, completion: @escaping (ApiType.ResponseType) -> Void) {
        self.request(api, callbackQueue: callbackQueue, progress: progress) { result in
            switch result {
            case let .success(data): completion(data)
            default: break
            }
        }
    }
    // MARK: ApiManager默认实现辅助方法及类型
    ///成功时调用
    public static func onCompletionSuccess<ApiType: EasyResponseApiType>(plugins: [PluginType],api: ApiType ,response: ApiType.ResponseType, completion:(Swift.Result<ApiType.ResponseType, Error>) -> Void) {
        let easyPlugins = plugins.compactMap({ $0 as? EasyApiPluginType })
        easyPlugins.forEach({ $0.willReceive(response, target: api) })
        completion(.success(response))
        easyPlugins.forEach({ $0.didReceive(response, target: api) })
    }
    public static func mappingError(_ info:String) -> Error {
        return NSError(domain: "EasyApiManager", code: 999, userInfo: [NSLocalizedDescriptionKey: info])
    }
}
// MARK: 下载套用的对象
fileprivate class EasyDownloadApiTargetWapper<ApiType: EasyDownloadApiType>: EasyApiType {
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
// MARK: Moya错误内容扩展

extension MoyaError: EasyTextualizable {
    ///比较友好的给用户看的信息
    public var text: String {
        switch self {
        case .statusCode(let res):
            switch res.statusCode {
            case 404: return "数据异常"
            default: break
            }
        case .underlying(let e, _):
            switch (e as NSError).code {
            case -1001: return "请求超时"
            case -1009: return "网络已中断"
            case -1004, -1005: return "网络连接失败"
            default:break
            }
        default: break
        }
        return self.localizedDescription
    }
}
// MARK: 默认ApiManager

///默认的ApiManager
public struct EasyApiManager: EasyApiManagerType {
    
}
