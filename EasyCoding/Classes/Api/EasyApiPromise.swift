//
//  EasyApiPromise.swift
//  EasyComponents
//
//  Created by 范晓鑫 on 2021/2/18.
//
#if canImport(PromiseKit)

import UIKit
import Moya
import PromiseKit

public extension Resolver {
    /// Resolves the promise with the provided result
    func resolve<ErrorType>(_ result: Swift.Result<T, ErrorType>) {
        switch result {
        case let .success(data): self.fulfill(data)
        case let .failure(error): self.reject(error)
        }
    }
}
// MARK: Api
public extension EasyResponseApiType {
    func promise(callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none) -> Promise<ResponseType> {
        return Promise { (seal) in
            self.request(callbackQueue: callbackQueue, progress: progress, completion: seal.resolve)
        }
    }
}
public extension EasyResponseApiType where Self: AnyObject {
    func promise(callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none) -> Promise<ResponseType> {
        return Promise { [weak self] (seal) in
            self?.request(callbackQueue: callbackQueue, progress: progress, completion: seal.resolve)
        }
    }
}
#endif
