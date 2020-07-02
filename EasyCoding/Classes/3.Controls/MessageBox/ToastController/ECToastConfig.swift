//
//  ToastConfig.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/22.
//

import UIKit

public class ECToastConfig {
    ///全局配置
    public static let `default` = Default()
    required public init() {
        
    }
    ///是否在全局配置的基础上覆盖，若为否则不加载全局配置，仅使用当前配置
    public var isBaseOnDefault: Bool = true
    
    ///最外围的视图
    public let container = ECControlConfig<UIView>()
    ///消息
    public let message = ECControlConfig<ECLabel>()
    ///显示动画
    public var animationForShow: ((ECToastView, @escaping () -> Void) -> Void)?
    ///关闭动画，执行完需调用第二个参数回调
    public var animationForDismiss: ((ECToastView, @escaping () -> Void) -> Void)?
    
    ///配置默认样式
    public class Default: ECToastConfig {
        required init() {
            super.init()
            //容器底部居中
            self.container.style(.bg(.lightGray) ,.corner(16))
            self.container.layout(.greather(.marginX(20)), .bottom(75 + UIView.easy.safeArea.bottom), .centerX, .greather(.height(32)))
            //消息
            self.message.style(.color(.white), .font(size: UIFont.systemFontSize), .lines())
            self.message.layout(.margin(15, 8))
            //显示动画
            self.animationForShow = nil
            //关闭动画
            self.animationForDismiss = { view, completion in
                UIView.animate(withDuration: 2.5, animations: {
                    view.container.alpha = 0
                }) { (_) in
                    completion()
                }
            }
        }
    }
}
