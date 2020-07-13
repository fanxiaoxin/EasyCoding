//
//  ViewDataDecorator.swift
//  EasyCoding_Example
//
//  Created by JY_NEW on 2020/7/11.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import EasyCoding

class ViewDataDecorator<DataProviderType: ECDataProviderType>: ECViewDataDecorator<DataProviderType> {
    override init() {
        super.init()
        self.loading.loadingView = DataLoadingView()
//        self.error.errorView = DataEmptyView()
        self.empty.emptyView = DataEmptyView()
    }
}
