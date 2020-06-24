//
//  ECDataVisualizedDecoratorType.swift
//  EasyCoding
//
//  Created by 范晓鑫 on 2020/6/25.
//

import UIKit

///数据请求可视化装饰器，如添加空数据页、请求错误页、请求加载Loading动画等
public protocol ECDataVisualizedDecoratorType: ECDataProviderDecoratorType {
    ///可视化的目标视图
    var targetView: UIView? { get set }
    ///装载可视化界面
    func load()
    ///卸载可视化界面
    func unload()
}

extension ECDataVisualizedDecoratorType {
    public typealias DataType = DataProviderType.DataType
}
