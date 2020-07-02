//
//  ECDataEmptyDecorator.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/30.
//

import UIKit

open class ECDataEmptyPlugin<DataType>: ECDataEmptyPluginBase<DataType> {
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
    
    ///配置，可修改布局及加载隐藏动画
    public let config = ECCustomControlConfig<UIView>(layouts: [.center])
    
    open override func load() {
        if let targetView = self.targetView {
            self.config.show(self.emptyView, at: targetView)
        }
    }
    
    open override func unload() {
        self.config.dismiss(self.emptyView)
    }
}
