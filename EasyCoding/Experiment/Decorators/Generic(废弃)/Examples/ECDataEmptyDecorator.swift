//
//  ECDataEmptyDecorator.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/30.
//

import UIKit

open class ECDataEmptyDecorator<DataType>: ECDataEmptyDecoratorType {
    public var dataProvider: ((@escaping (Result<DataType, Error>) -> Void, @escaping (Result<DataType, Error>) -> Void) -> Void)?
    ///开始请求时卸载
    open var unloadIfRequest: Bool = true
    ///要加载到的页面，若为空则加载到keywindow
    open weak var targetView: UIView?
    ///空数据页
    open lazy var emptyView: UIView = {
        let view = UIView()
        let image = UIImage.init(named: "data_empty", in: .easyCoding, compatibleWith: nil)
        view.easy.add(UIImageView.easy(.image(image)), layout: .top, .centerX)
            .next(.label(.font(ECSetting.Font.normal), .color(ECSetting.Color.light), .text("暂无数据")), layout: .bottomTop(15))
        .parent(.marginX, .bottom)
        return view
    }()
    public init() {
        
    }
    
    open func load() {
        self.targetView?.easy.add(self.emptyView, layout: .center)
    }
    
    open func unload() {
        self.emptyView.removeFromSuperview()
    }
}
