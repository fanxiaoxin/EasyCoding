//
//  AlertController.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/20.
//

import UIKit
import YYKeyboardManager

open class ECAlertController: ECViewController<ECAlertView>,YYKeyboardObserver {
    ///内容视图
    public let contentView: UIView
    ///按钮及操作
    public let buttons: [Button]
    ///配置
    public let config: ECAlertConfig?
    ///用于缓存原来的keyWindow
    private weak var keyWindow: UIWindow?
    private lazy var keyboardTap:UITapGestureRecognizer? = {
        return UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
    }()
    ///初始化必传参数
    public init(title: String? = ECAlertConfig.default.commonTitle, contentView: UIView, buttons: [Button], config: ECAlertConfig? = nil) {
        self.contentView = contentView
        self.buttons = buttons
        self.config = config
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.page.buttons = self.buttons.map({ (button) in
            return ECAlertView.Button(sizeRatio: button.sizeRatio, type: button.type, text: button.text) { [weak self] in
                if let s = self {
                    button.action?(s)
                }
            }
        })
        self.page.config = self.config
        //加载页面
        self.page.delayLoad()
        //有标题显示标题，没标题则隐藏
        if let title = self.title {
            self.page.titleLabel.text = title
            self.page.titleLabel.superview?.isHidden = false
        }else{
            self.page.titleLabel.superview?.isHidden = true
        }
        
        self.page.contentView.easy.add(self.contentView, layout: .margin)
    }
    //控制键盘
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //添加键盘管理
        YYKeyboardManager.default().add(self)
    }
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //去掉键盘管理
        YYKeyboardManager.default().remove(self)
    }
    public func keyboardChanged(with transition: YYKeyboardTransition) {
        //键盘更新
        self.page.keyboardContainer.snp.updateConstraints { (maker) in
            maker.height.equalTo(transition.toFrame.origin.y)
        }
        UIView.animate(withDuration: transition.animationDuration, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
        if let tap = self.keyboardTap {
            if transition.toVisible.boolValue {
                if tap.view == nil {
                    self.view.addGestureRecognizer(tap)
                }
                tap.isEnabled = true
            }else{
                tap.isEnabled = false
            }
        }
    }
    @objc func closeKeyboard(){
        self.view.endEditing(true)
    }
    ///显示
    open func show(completion: (() -> Void)? = nil) {
        self.keyWindow = UIApplication.shared.keyWindow
        self.easy.openWindow(level: .alert, makeKey: true)
        if let animation = (self.config?.presentAnimation ?? ECAlertConfig.default.presentAnimation){
            animation.show(view: self.page.container) {
                completion?()
            }
        }else{
            completion?()
        }
    }
    ///关闭
    open func dismiss(completion: (() -> Void)? = nil) {
        if self.view.window?.isKeyWindow ?? false {
            self.keyWindow?.makeKey()
            self.keyWindow = nil
        }
        if let animation = (self.config?.presentAnimation ?? ECAlertConfig.default.presentAnimation) {
            animation.dismiss(view: self.page.container) { [weak self] in
                self?.easy.closeWindow()
                completion?()
            }
        }else{
            self.easy.closeWindow()
            completion?()
        }
    }
}
extension ECAlertController {
    ///按钮设置
    public struct Button {
        ///按钮类型
        public var type: ECAlertView.ButtonType = .normal
        ///显示文本
        public var text: String?
        ///点击事件
        public var action: ((ECAlertController) -> Void)?
        ///按钮的尺寸比例，会跟传入的按钮相比较，按比例分配高宽
        public var sizeRatio: CGFloat = 1
        public init(sizeRatio: CGFloat = 1, type: ECAlertView.ButtonType = .normal, text: String?, action: ((ECAlertController) -> Void)?) {
            self.sizeRatio = sizeRatio
            self.type = type
            self.text = text
            self.action = action
        }
    }
    ///常见的按钮类型
    public enum CommonButtonType: Hashable {
        ///取消
        case cancel
        ///确定
        case confirm
        ///自定义
        case custom(Int)
    }
}

extension ECAlertController.Button {
    ///取消按钮
    public static var cancel: Self {
        if let btn = ECAlertConfig.default.commonButtons[.cancel] {
            return btn
        }
        fatalError("未配置取消按钮")
    }
    ///取消按钮
    public static func cancel(_ text: String) -> Self {
        var btn = self.cancel
        btn.text = text
        return btn
    }
    ///确定按钮
    public static func confirm(_ text: String? = nil, action: @escaping (ECAlertController) -> Void) -> Self {
        if var btn = ECAlertConfig.default.commonButtons[.confirm] {
            if let t = text {
                btn.text = t
            }
            btn.action = action
            return btn
        }
        fatalError("未配置取消按钮")
    }
}
