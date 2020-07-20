//
//  ECDataPrecondition.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/20.
//

import UIKit

open class ECDataPrecondition<DataProviderType: ECDataProviderType>: ECPrecondition<DataProviderType,DataProviderType.DataType> {
    let dataProvider: DataProviderType
    let verfiyAction: (Result<DataProviderType.DataType, Error>)->Bool
    public init(_ dataProvider: DataProviderType, verify: @escaping (Result<DataProviderType.DataType, Error>)->Bool) {
        self.dataProvider = dataProvider
        self.verfiyAction = verify
        super.init()
    }
    public override func verify() {
        self.dataProvider.easyData { [weak self] (result) in
            self?.finished(self!.verfiyAction(result))
        }
    }
}

extension ECPrecondition {
    public static func data<DataProviderType: ECDataProviderType>(_ dataProvider: DataProviderType,verify: @escaping (Result<DataProviderType.DataType, Error>)->Bool) -> ECDataPrecondition<DataProviderType> {
        return ECDataPrecondition<DataProviderType>(dataProvider, verify: verify)
    }
    public static func data<DataProviderType: ECDataProviderType>(_ dataProvider: DataProviderType,verify: @escaping (DataProviderType.DataType)->Bool) -> ECDataPrecondition<DataProviderType> {
        return ECDataPrecondition<DataProviderType>(dataProvider, verify: { result in
            switch result {
            case let .success(data): return verify(data)
            case .failure(_): return false
            }
        })
    }
}
