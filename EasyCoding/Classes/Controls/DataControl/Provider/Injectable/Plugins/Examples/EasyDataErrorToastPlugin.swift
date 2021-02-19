//
//  EasyDataErrorToastDecorator.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/30.
//
#if EASY_DATA

import UIKit

///请求失败时弹toast信息
open class EasyDataErrorToastPlugin<DataType>: EasyDataErrorPluginBase<DataType> {
    open override func load() {
        if let message =  self.error?.friendlyText {
            EasyMessageBox.toast(message)
        }
    }
}

extension EasyDataPlugin {
    ///弹错误toast
    public static func errorToast() -> EasyDataErrorToastPlugin<DataType> {
        return EasyDataErrorToastPlugin<DataType>()
    }
}

#endif
