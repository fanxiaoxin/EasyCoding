//
//  EasyDataPromise.swift
//  EasyComponents
//
//  Created by 范晓鑫 on 2021/2/18.
//

#if canImport(PromiseKit)

import UIKit
import PromiseKit

// MARK: DataProvider
public extension EasyDataProviderType {
    func promise() -> Promise<DataType> {
        return Promise { (seal) in
            self.easyData(completion: seal.resolve)
        }
    }
}
public extension EasyDataProviderType where Self: AnyObject {
    func promise() -> Promise<DataType> {
        return Promise { [weak self] (seal) in
            self?.easyData(completion: seal.resolve)
        }
    }
}
#endif
