//
//  ECDataErrorToastDecorator.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/30.
//

import UIKit

///请求失败时弹toast信息
open class ECDataErrorToastPlugin<DataType>: ECDataErrorPluginBase<DataType> {
    deinit {
        print(NSStringFromClass(Self.self) + "die")
    }
    
    open override func load() {
        if let message = self.error?.localizedDescription {
            ECMessageBox.toast(message)
        }
    }
}
