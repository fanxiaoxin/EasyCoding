//
//  ECDataListChainProviderType.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/6.
//

import UIKit

///将两个数据提供器合并成一个
open class ECDataProviderMerger<FirstType: ECDataProviderType, SecondType: ECDataProviderType>: ECDataProviderType {
    public typealias DataType = SecondType.DataType
    
    ///第一个数据提供器
    public var first: FirstType?
    ///第二个数据提供器
    public var second: SecondType?
    
    ///连接两个数据的操作
    public var connect: (FirstType.DataType, SecondType) -> Void
    
    public init(first: FirstType, second: SecondType, connect: @escaping (FirstType.DataType, SecondType) -> Void) {
        self.first = first
        self.second = second
        self.connect = connect
    }
    
    public func easyData(completion: @escaping (Result<SecondType.DataType, Error>) -> Void) {
        self.first?.easyData(completion: { [weak self] (result) in
            switch result {
            case let .success(data):
                if let s = self, let second = s.second {
                    s.connect(data, second)
                    second.easyData(completion: completion)
                }
            case let .failure(error): completion(.failure(error))
            }
        })
    }
}
extension ECDataProviderType {
    public func merge<DataProviderType: ECDataProviderType>(_ other: DataProviderType, connect: @escaping (Self.DataType, DataProviderType) -> Void) -> ECDataProviderMerger<Self, DataProviderType> {
        return ECDataProviderMerger<Self, DataProviderType>(first: self, second: other, connect: connect)
    }
}
