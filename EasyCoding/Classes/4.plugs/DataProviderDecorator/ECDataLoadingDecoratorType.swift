//
//  ECDataLoadingDecoratorType.swift
//  EasyCoding
//
//  Created by 范晓鑫 on 2020/6/25.
//

import UIKit

///抽象的数据请求中页面，比如菊花或者自定义的炫酷加载动画
public protocol ECDataLoadingViewType: UIView {
    
}
///数据请求中装饰器，用于在数据请求过程中包装请求动画，如：菊花
public protocol ECDataLoadingDecoratorType: ECDataVisualizedDecoratorType {
    var loadingView: ECDataLoadingViewType { get }
}
///请求动画的默认添加方式，可直接重写
extension ECDataLoadingDecoratorType {
    ///请求前将加载页面
    public func willRequest() -> Bool {
        self.load()
        return true
    }
    ///请求结束后卸载页面
    public func didResponse() {
        self.unload()
    }
    ///默认添加到目标显示页面中间
    public func load() {
        self.targetView?.easy.add(self.loadingView, layout: .center)
    }
    ///默认将加载页面删除
    public func unload() {
        self.loadingView.removeFromSuperview()
    }
}
