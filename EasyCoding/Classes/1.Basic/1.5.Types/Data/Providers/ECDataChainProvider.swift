//
//  ECDataListChainProviderType.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/6.
//

import UIKit

public protocol ECDataProviderChainable: ECDataProviderType {
    associatedtype InputDataType
    ///上一个数据结果
    var inputData: InputDataType { get set }
}
///将两个数据提供器合并成一个
open class ECDataChainProvider<FirstDataProviderProviderType: ECDataProviderType, SecondDataProviderType: ECDataProviderChainable>: ECDataProviderType where SecondDataProviderType.InputDataType == FirstDataProviderProviderType.DataType {
    public typealias DataType = SecondDataProviderType.DataType
    
    ///第一个数据提供器
    public var first: FirstDataProviderProviderType?
    ///第二个数据提供器
    public var second: SecondDataProviderType?
    
    public func easyData(completion: @escaping (Result<SecondDataProviderType.DataType, Error>) -> Void) {
        self.first?.easyData(completion: { [weak self] (result) in
            switch result {
            case let .success(data):
                self?.second?.inputData = data
                self?.second?.easyData(completion: completion)
            case let .failure(error): completion(.failure(error))
            }
        })
    }
}
