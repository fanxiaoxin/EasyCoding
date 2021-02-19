//
//  ProtocolControlConfig.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/23.
//

import UIKit

///自定义控件的配置
open class EasyCustomControlConfig<ViewType: UIView>: EasyControlConfig<ViewType> {
    ///自定义控件
    public var viewBuilder: (() -> ViewType)?
    ///呈现动画
    public var presentAnimation: EasyPresentAnimationType?
    
    public init(viewBuilder: (() -> ViewType)? = nil, layouts: [EasyViewLayout]) {
        self.viewBuilder = viewBuilder
        super.init(styles: [], layouts: layouts)
    }
    ///在指定的页面上显示
    open func show(_ view: ViewType, at superView: UIView) {
        superView.addSubview(view)
        self.apply(for: view)
        self.presentAnimation?.show(view: view, completion: nil)
    }
    ///隐藏
    open func dismiss(_ view: ViewType) {
        if let animation = self.presentAnimation {
            animation.dismiss(view: view) { [weak view] in
                view?.removeFromSuperview()
            }
        }else{
            view.removeFromSuperview()
        }
    }
}
