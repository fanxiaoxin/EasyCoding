//
//  ECApiPromise.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/28.
//

import UIKit
import PromiseKit
import Moya

public extension Resolver {
    /// Resolves the promise with the provided result
    func resolve<ErrorType>(_ result: Swift.Result<T, ErrorType>) {
        switch result {
        case let .success(data): self.fulfill(data)
        case let .failure(error): self.reject(error)
        }
    }
}

// MARK: Condition
public extension ECConditionType {
    func promise() -> Guarantee<ResultType> {
        return Guarantee { (seal) in
            self.check(completion: seal)
        }
    }
}
public extension ECConditionType where Self: AnyObject {
    func promise() -> Guarantee<ResultType> {
        return Guarantee { [weak self] (seal) in
            self?.check(completion: seal)
        }
    }
}
// MARK: DataProvider
public extension ECDataProviderType {
    func promise() -> Promise<DataType> {
        return Promise { (seal) in
            self.easyData(completion: seal.resolve)
        }
    }
}
public extension ECDataProviderType where Self: AnyObject {
    func promise() -> Promise<DataType> {
        return Promise { [weak self] (seal) in
            self?.easyData(completion: seal.resolve)
        }
    }
}
// MARK: Event
public extension ECEventManagerType {
    func promise() -> Promise<EventParameterType> {
        let identifier = Date.timeIntervalBetween1970AndReferenceDate.description
        return Promise { (seal) in
            self.add(identifier, block: seal.fulfill)
        }.ensure {
            self.remove(identifier)
        }
    }
}
public extension ECEventManagerType where Self: AnyObject {
    func promise() -> Promise<EventParameterType> {
        let identifier = Date.timeIntervalBetween1970AndReferenceDate.description
        return Promise { [weak self] (seal) in
            self?.add(identifier, block: seal.fulfill)
        }.ensure { [weak self] in
            self?.remove(identifier)
        }
    }
}
public extension ECEventPublisherType {
    func promise(_ event: EventType) -> Promise<ECNull> {
        let identifier = Date.timeIntervalBetween1970AndReferenceDate.description
        return Promise { (seal) in
            self.register(event: event, identifier: identifier) {
                seal.fulfill(ecNull)
            }
        }.ensure {
            self.unregister(event: event, identifier: identifier)
        }
    }
}
public extension ECEventPublisherType where Self: AnyObject{
    func promise(_ event: EventType) -> Promise<ECNull> {
        let identifier = Date.timeIntervalBetween1970AndReferenceDate.description
        return Promise { [weak self](seal) in
            self?.register(event: event, identifier: identifier) {
                seal.fulfill(ecNull)
            }
        }.ensure { [weak self] in
            self?.unregister(event: event, identifier: identifier)
        }
    }
}
// MARK: Api
public extension ECResponseApiType {
    func promise(callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none) -> Promise<ResponseType> {
        return Promise { (seal) in
            self.request(callbackQueue: callbackQueue, progress: progress, completion: seal.resolve)
        }
    }
}
public extension ECResponseApiType where Self: AnyObject {
    func promise(callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none) -> Promise<ResponseType> {
        return Promise { [weak self] (seal) in
            self?.request(callbackQueue: callbackQueue, progress: progress, completion: seal.resolve)
        }
    }
}

