//
//  ECDataEmptyPlugin.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/1.
//

import UIKit

///抽象类，需继承重载
open class ECDataEmptyPluginBase<DataType>: ECDataPlugin<DataType> {
    ///开始请求时卸载
    open var unloadWhenRequest: Bool = true
    ///判断是否为空，可自定义
    open var isEmpty: (DataType) -> Bool = { data in
        if let content = data as? ECEmptiable, content.isEmpty {
            return true
        }else{
            return false
        }
    }
    ///请求时不显示自身
    open override func didRequest() {
        super.didRequest()
        if self.unloadWhenRequest {
            self.unload()
        }
    }
    ///请求结束后如成功但数据为空则显示空数据页面，但不中断回调，防止干扰业务
    open  override func didResponse(for result: Result<DataType, Error>, completion: @escaping (Result<DataType, Error>) -> Void) {
        super.didResponse(for: result, completion: completion)
        switch result {
        case let .success(data):
            if self.isEmpty(data) {
                self.load()
            }else{
                self.unload()
            }
        case .failure(_):
            self.unload()
        }
    }
    ///装载可视化界面
    open func load() {}
    ///卸载可视化界面
    open func unload() {}
}
