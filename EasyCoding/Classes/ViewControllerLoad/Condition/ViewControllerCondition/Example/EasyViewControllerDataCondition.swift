//
//  EasyDataPrecondition.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/20.
//

import UIKit

#if EASY_DATA

open class EasyViewControllerDataCondition<DataProviderType: EasyDataProviderType>: EasyViewControllerCondition {
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

extension EasyViewControllerCondition {
    public static func data<DataProviderType: EasyDataProviderType>(_ dataProvider: DataProviderType,action: @escaping (Result<DataProviderType.DataType, Error>)->Bool) -> EasyViewControllerDataCondition<DataProviderType> {
        return EasyViewControllerDataCondition(dataProvider, action: action)
    }
    public static func data<DataProviderType: EasyDataProviderType>(_ dataProvider: DataProviderType,verify: @escaping (DataProviderType.DataType)->Bool) -> EasyViewControllerDataCondition<DataProviderType> {
        return EasyViewControllerDataCondition(dataProvider, action: { result in
            switch result {
            case let .success(data): return verify(data)
            case .failure(_): return false
            }
        })
    }
}

#endif
