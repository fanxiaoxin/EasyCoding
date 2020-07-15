//
//  ApiAccessable.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/11/26.
//

import UIKit
import Moya

// MARK: 普通接口
extension ECResponseApiType {
    public func request(callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none, completion: @escaping (Swift.Result<ResponseType, Error>) -> Void) {
        self.manager.request(self, callbackQueue: callbackQueue, progress: progress, completion: completion)
    }
    public func requestWithoutError(callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none, completion: @escaping (ResponseType) -> Void) {
        self.manager.requestWithoutError(self, callbackQueue: callbackQueue, progress: progress, completion: completion)
    }
}
// MARK: 上传
//extension ECUploadApiType {
//    public func request(callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none, completion: @escaping (Swift.Result<ResponseType, Error>) -> Void) {
//        self.manager.request(self, callbackQueue: callbackQueue, progress: progress, completion: completion)
//    }
//}
// MARK: 下载
//extension ECDownloadApiType {
//    public func request(callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none, completion: @escaping (Swift.Result<ResponseType, Error>) -> Void) {
//        self.manager.request(self, callbackQueue: callbackQueue, progress: progress, completion: completion)
//    }
//}

extension ECResponseApiType {
    public func easyData(completion: @escaping (Swift.Result<DataType, Error>) -> Void) {
        self.request(completion: completion)
    }
}
