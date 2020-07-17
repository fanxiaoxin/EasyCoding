//
//  ECDataListChainProviderType.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/6.
//

import UIKit

///将两个数据提供器合并成一个，第一个执行完再执行第二个
open class ECDataProviderSerialMerger<FirstType: ECDataProviderType, SecondType: ECDataProviderType>: ECDataProviderType {
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

///将两个数据提供器合并成一个，第一个执行完再执行第二个
open class ECDataProviderParallelMerger<FirstType: ECDataProviderType, SecondType: ECDataProviderType, ResultType>: ECDataProviderType {
    public typealias DataType = ResultType
    public typealias ResultMapping = (Result<FirstType.DataType, Error>, Result<SecondType.DataType, Error>) -> Result<ResultType, Error>
    
    ///第一个数据提供器
    public var first: FirstType?
    ///第二个数据提供器
    public var second: SecondType?
    
    ///将两个结果转换为目标格式
    public var resultMapping: ResultMapping
    
    ///缓存第一个结果
    private var firstResult: Result<FirstType.DataType, Error>?
    ///缓存第二个结果
    private var secondResult: Result<SecondType.DataType, Error>?
    
    public init(first: FirstType, second: SecondType, result mapping: @escaping ResultMapping) {
        self.first = first
        self.second = second
        self.resultMapping = mapping
    }
    
    public func easyData(completion: @escaping (Result<DataType, Error>) -> Void) {
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "com.easyCoding.DataSerial")
        group.enter()
        queue.async(group: group) {
            self.first?.easyData(completion: { [weak self] (result) in
                self?.firstResult = result
                group.leave()
            }) ?? group.leave()
        }
        group.enter()
        queue.async(group: group) {
            self.second?.easyData(completion: { [weak self] (result) in
                self?.secondResult = result
                group.leave()
            }) ?? group.leave()
        }
        group.notify(queue: .main) {
            if let first = self.firstResult, let second = self.secondResult {
                completion(self.resultMapping(first, second))
            }else{
                completion(.failure(ECDataError<DataType>("first或second数据提供器未设置")))
            }
        }
    }
}
extension ECDataProviderType {
    ///串行第二个数据提供器，第一个执行完才执行第二个
    public func serial<DataProviderType: ECDataProviderType>(_ other: DataProviderType, connect: @escaping (Self.DataType, DataProviderType) -> Void) -> ECDataProviderSerialMerger<Self, DataProviderType> {
        return ECDataProviderSerialMerger<Self, DataProviderType>(first: self, second: other, connect: connect)
    }
    ///并行第二个数据提供器，全部执行完才返回
    public func parallel<DataProviderType: ECDataProviderType, ResultType>(_ other: DataProviderType, result mapping: @escaping ECDataProviderParallelMerger<Self, DataProviderType, ResultType>.ResultMapping) -> ECDataProviderParallelMerger<Self, DataProviderType, ResultType> {
        return ECDataProviderParallelMerger<Self, DataProviderType, ResultType>(first: self, second: other, result: mapping)
    }
}
