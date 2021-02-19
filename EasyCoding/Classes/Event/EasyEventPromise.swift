//
//  File.swift
//  EasyComponents
//
//  Created by 范晓鑫 on 2021/2/18.
//

#if canImport(PromiseKit)

import UIKit
import PromiseKit

// MARK: Event
public extension EasyEventManagerType {
    func promise() -> Promise<EventParameterType> {
        let identifier = Date.timeIntervalBetween1970AndReferenceDate.description
        return Promise { (seal) in
            self.add(identifier, block: seal.fulfill)
        }.ensure {
            self.remove(identifier)
        }
    }
}
public extension EasyEventManagerType where Self: AnyObject {
    func promise() -> Promise<EventParameterType> {
        let identifier = Date.timeIntervalBetween1970AndReferenceDate.description
        return Promise { [weak self] (seal) in
            self?.add(identifier, block: seal.fulfill)
        }.ensure { [weak self] in
            self?.remove(identifier)
        }
    }
}
public extension EasyEventPublisherType {
    func promise(_ event: EventType) -> Promise<EasyNull> {
        let identifier = Date.timeIntervalBetween1970AndReferenceDate.description
        return Promise { (seal) in
            self.register(event: event, identifier: identifier) {
                seal.fulfill(easyNull)
            }
        }.ensure {
            self.unregister(event: event, identifier: identifier)
        }
    }
}
public extension EasyEventPublisherType where Self: AnyObject{
    func promise(_ event: EventType) -> Promise<EasyNull> {
        let identifier = Date.timeIntervalBetween1970AndReferenceDate.description
        return Promise { [weak self](seal) in
            self?.register(event: event, identifier: identifier) {
                seal.fulfill(easyNull)
            }
        }.ensure { [weak self] in
            self?.unregister(event: event, identifier: identifier)
        }
    }
}
#endif
