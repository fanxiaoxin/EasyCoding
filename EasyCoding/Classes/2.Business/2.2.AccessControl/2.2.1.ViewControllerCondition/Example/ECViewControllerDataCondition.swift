//
//  ECDataPrecondition.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/20.
//

import UIKit

open class ECViewControllerDataCondition<DataProviderType: ECDataProviderType>: ECViewControllerCondition {
    let dataProvider: DataProviderType
    let checkAction: (Result<DataProviderType.DataType, Error>)->Bool
    public init(_ dataProvider: DataProviderType, action: @escaping (Result<DataProviderType.DataType, Error>)->Bool) {
        self.dataProvider = dataProvider
        self.checkAction = action
        super.init()
    }
    public override func check(completion: @escaping (Bool) -> Void) {
        self.dataProvider.easyData { [weak self] (result) in
            completion(self!.checkAction(result))
        }
    }
}

extension ECViewControllerCondition {
    public static func data<DataProviderType: ECDataProviderType>(_ dataProvider: DataProviderType,action: @escaping (Result<DataProviderType.DataType, Error>)->Bool) -> ECViewControllerDataCondition<DataProviderType> {
        return ECViewControllerDataCondition(dataProvider, action: action)
    }
    public static func data<DataProviderType: ECDataProviderType>(_ dataProvider: DataProviderType,verify: @escaping (DataProviderType.DataType)->Bool) -> ECViewControllerDataCondition<DataProviderType> {
        return ECViewControllerDataCondition(dataProvider, action: { result in
            switch result {
            case let .success(data): return verify(data)
            case .failure(_): return false
            }
        })
    }
}
