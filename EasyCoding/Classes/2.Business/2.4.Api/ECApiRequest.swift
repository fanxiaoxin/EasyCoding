//
//  ApiAccessable.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/11/26.
//

import UIKit
import Moya
import HandyJSON
import Alamofire

fileprivate func mappingError(_ info:String) -> Error {
    return NSError(domain: "ECApiRequest", code: 999, userInfo: [NSLocalizedDescriptionKey: info])
}
// MARK: 普通接口
extension ECResponseApiType {
    public func request(callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none, completion: @escaping (Swift.Result<ResponseType, Error>) -> Void) {
        self.manager.provider(for: self).request(self, callbackQueue: callbackQueue, progress: progress) { (result) in
            switch result {
            case let .success(response):
                do {
                    if let json = try response.mapJSON() as? NSDictionary,
                        let s = ResponseType.deserialize(from: json){
                        if let error = s.error {
                            completion(.failure(error))
                        }else{
                            completion(.success(s))
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
    public func requestWithoutError(callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none, completion: @escaping (ResponseType) -> Void) {
        self.request(callbackQueue: callbackQueue, progress: progress) { result in
            switch result {
            case let .success(data): completion(data)
            default: break
            }
        }
    }
}
// MARK: 上传
extension ECUploadApiType {
    public func request(callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none, completion: @escaping (Swift.Result<ResponseType, Error>) -> Void) {
        self.manager.provider(for: self).request(self, callbackQueue: callbackQueue, progress: progress) { (result) in
            switch result {
            case .success(_): completion(.success(.null))
            case let .failure(error): completion(.failure(error))
            }
        }
    }
}
// MARK: 下载
internal class ECDownloadApiTargetWapper<ApiType: ECDownloadApiType>: ECApiType {
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

extension ECDownloadApiType {
    public func request(callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none, completion: @escaping (Swift.Result<ResponseType, Error>) -> Void) {

        let target = ECDownloadApiTargetWapper<Self>(api: self)
        self.manager.provider(for: target).request(target, callbackQueue: callbackQueue, progress: progress) { (result) in
            switch result {
            case .success(_):
                if let url = target.destinationURL {
                    completion(.success(url))
                }else{
                    completion(.failure(mappingError("文件保存地址为空")))
                }
            case let .failure(error): completion(.failure(error))
            }
        }
    }
}

extension ECResponseApiType {
    public func easyData(completion: @escaping (Swift.Result<DataType, Error>) -> Void) {
        self.request(completion: completion)
    }
}
