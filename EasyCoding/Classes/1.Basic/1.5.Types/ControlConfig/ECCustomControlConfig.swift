//
//  ProtocolControlConfig.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/23.
//

import UIKit

///自定义控件的配置
open class ECCustomControlConfig<ViewType: UIView>: ECControlConfig<ViewType> {
    ///显示动画
    public var animationForShow: ((ViewType) -> Void)?
    ///关闭动画，执行完需调用第二个参数回调
    public var animationForDismiss: ((ViewType, @escaping () -> Void) -> Void)?
    
    public init(layouts: [ECViewLayout]) {
        super.init(styles: [], layouts: layouts)
    }
    ///在指定的页面上显示
    open func show(_ view: ViewType, at superView: UIView) {
        superView.addSubview(view)
        self.apply(for: view)
        self.animationForShow?(view)
    }
    ///隐藏
    open func dismiss(_ view: ViewType) {
        if let animation = self.animationForDismiss {
            animation(view) { [weak view] in
                view?.removeFromSuperview()
            }
        }else{
            view.removeFromSuperview()
        }
    }
}
