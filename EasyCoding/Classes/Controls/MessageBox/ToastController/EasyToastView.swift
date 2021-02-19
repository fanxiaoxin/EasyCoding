//
//  ToastView.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/22.
//

import UIKit

open class EasyToastView: UIView {
    ///单独配置
    public var config: EasyToastConfig? = nil
    ///最外围的视图
    public let container = UIView()
    ///消息
    public let messageLabel = EasyLabel()
    
    public init(message: String, config: EasyToastConfig? = nil) {
        super.init(frame: .zero)
        self.messageLabel.text = message
        self.config = config
        self.load()
    }
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.load()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.load()
    }
    ///子类重载该方法即可
    open func load() {
        self.easy(.bg(.clear), .userInteraction(false))
        
        self.addSubview(container)
        self.apply(self.container, { $0.container })
        
        container.addSubview(messageLabel)
        self.apply(self.messageLabel, { $0.message })
    }
    ///显示
    open func show(completion: (() -> Void)? = nil) {
        let window = UIWindow.easy.topWindow ?? UIApplication.shared.keyWindow!
        window.easy.add(self, layout: .margin)
        if let animation = (self.config?.animationForShow ?? EasyToastConfig.default.animationForShow){
            animation(self) {
                self.dismiss(completion: completion)
            }
        }else{
            self.dismiss(completion: completion)
        }
    }
    ///关闭
    open func dismiss(completion: (() -> Void)? = nil) {
        if let animation = (self.config?.animationForDismiss ?? EasyToastConfig.default.animationForDismiss) {
            animation(self) { [weak self] in
                self?.removeFromSuperview()
                completion?()
            }
        }else{
            self.removeFromSuperview()
            completion?()
        }
    }
    ///加载配置
    open func loadConfig<ReturnType>(_ action: (EasyToastConfig) -> ReturnType) -> ReturnType{
        if let cfg = self.config {
            if cfg.isBaseOnDefault {
                _ = action(EasyToastConfig.default)
            }
            return action(cfg)
        }else{
            return action(EasyToastConfig.default)
        }
    }
    ///加载样式
    public func apply<ViewType: UIView>(_ view: ViewType, _ action: (EasyToastConfig) -> EasyControlConfig<ViewType>?) {
        self.loadConfig { (config) -> Void in
            action(config)?.apply(for: view)
        }
    }
}
