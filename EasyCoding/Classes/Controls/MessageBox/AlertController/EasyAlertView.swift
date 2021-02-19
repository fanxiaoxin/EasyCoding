//
//  AlertController.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/18.
//

import UIKit
///弹窗
open class EasyAlertView: EasyPage {
    ///单独配置
    public var config: EasyAlertConfig? = nil
    ///按钮类型
    public enum ButtonType {
        ///普通按钮
        case normal
        ///积极，如OK，确定等按钮
        case positive
        ///消极，如取消等按钮
        case negative
        ///破坏性强的，如删除等按钮
        case destructive
    }
    ///按钮设置
    public struct Button {
        ///按钮的尺寸比例，会跟传入的按钮相比较，按比例分配高宽
        public var sizeRatio: CGFloat = 1
        ///按钮类型
        public var type: EasyAlertView.ButtonType = .normal
        ///显示文本
        public var text: String?
        ///点击事件
        public var action: (() -> Void)?
        public init(sizeRatio: CGFloat = 1, type: EasyAlertView.ButtonType = .normal, text: String?, action: (() -> Void)?) {
            self.sizeRatio = sizeRatio
            self.type = type
            self.text = text
            self.action = action
        }
    }
    ///键盘的占位，保持跟键盘同步
    internal let keyboardContainer = UIView()
    ///最外围的视图
    public let container = UIView()
    ///最外围的视图
    public let containerStack = UIStackView()
    ///标题
    public let titleLabel = EasyLabel()
    ///标题跟内容的分隔线
    public let titleSeparator = UIView()
    ///包裹内容容器
    public let contentScrollView = UIScrollView()
    ///内容容器，将需要显示的内容放在里面，一般为Label，也可自定义
    public let contentView = UIView()
    ///内容跟按钮的分隔线
    public let contentSeparator = UIView()
    ///放置所有按钮的容器
    public let buttonContainer = UIView()
    ///放置所有按钮的容器
    public let buttonContainerStack = UIStackView()
    ///设置按钮
    public var buttons: [Button]?
    ///延时加载，由Controller去调用，在这之前须将config(可空)和buttons配置好
    open func delayLoad() {
        //背景样式
        self.apply(self, { $0.background })
        
        let titleContainer = UIView()
        let titleSeparatorContainer = UIView()
        let contentContainer = UIView()
        let contentSeparatorContainer = UIView()
        let buttonContainerContainer = UIView()
        
        containerStack.easy.style(.views([titleContainer,
                                     titleSeparatorContainer,
                                     contentContainer,
                                     contentSeparatorContainer,
                                     buttonContainerContainer].easy.style(.bg(.clear), .highPriority()).base))
        
        self.easy.add(self.keyboardContainer.easy(.bg(.clear), .height(UIScreen.main.bounds.size.height)), layout: .top, .marginX)
        //最外围
        self.keyboardContainer.addSubview(self.container)
        self.apply(self.container, { $0.container })
        self.container.addSubview(self.containerStack)
        self.apply(self.containerStack, { $0.containerStack })
        
        ///标题
        titleContainer.addSubview(self.titleLabel)
        self.apply(self.titleLabel, { $0.title })
        
        ///标题跟内容的分隔线
        titleSeparatorContainer.addSubview(self.titleSeparator)
        self.apply(self.titleSeparator, { $0.titleSeparator })
        
        ///内容容器包裹，将需要显示的内容放在里面，一般为Label，也可自定义
        contentContainer.addSubview(self.contentScrollView)
        self.apply(self.contentScrollView, { $0.content })
        
        ///添加内容容器
        self.contentScrollView.addSubview(self.contentView)
        self.contentView.easy.style(.lowPriority())
        
        ///内容跟按钮的分隔线
        contentSeparatorContainer.addSubview(self.contentSeparator)
        self.apply(self.contentSeparator, { $0.contentSeparator })
        
        ///放置所有按钮的容器
        buttonContainerContainer.addSubview(self.buttonContainer)
        self.apply(self.buttonContainer, { $0.buttonContainer })
        self.buttonContainer.addSubview(self.buttonContainerStack)
        self.apply(self.buttonContainerStack, { $0.buttonContainerStack })
        
        //加载按钮
        self.loadButtons()
        //以下固定布局是为了UIScrollView尽可能地不出现滚动,外围可限制不超出屏幕，则当超出时会以滚动方式呈现
        self.contentScrollView.easy.layout(self.contentView, .margin, .priority(.width, .medium), .priority(.height, .medium))
    }
    ///加载按钮
    func loadButtons() {
        if let buttons = self.buttons, buttons.count > 0{
            let buttonContainer0 = self.createButton(for: buttons[0],tag: 0)
            self.buttonContainerStack.addArrangedSubview(buttonContainer0)
            if buttons.count > 1 {
                for i in 1..<buttons.count {
                    let buttonSeparatorContainer = UIView()
                    let buttonSeparator = UIView()
                    buttonSeparatorContainer.addSubview(buttonSeparator)
                    self.apply(buttonSeparator, { $0.buttonSeparator })
                    self.buttonContainerStack.addArrangedSubview(buttonSeparatorContainer)
                    
                    let buttonContainer = self.createButton(for: buttons[i],tag: i)
                    self.buttonContainerStack.addArrangedSubview(buttonContainer)
                    
                    buttonContainer.snp.makeConstraints { (make) in
                        if self.buttonContainerStack.axis == .horizontal {
                            make.width.equalTo(buttonContainer0).multipliedBy(buttons[i].sizeRatio / buttons[0].sizeRatio)
                        }else{
                            make.height.equalTo(buttonContainer0).multipliedBy(buttons[i].sizeRatio / buttons[0].sizeRatio)
                        }
                    }
                }
            }
        }
    }
    ///创建按钮
    func createButton(for setting: Button, tag: Int) -> UIView {
        let button = EasyButton()
        button.tag = tag
        button.addTarget(self, action: #selector(self.buttonClick(_:)), for: .touchUpInside)
        button.setTitle(setting.text, for: .normal)
        let container = UIView()
        container.addSubview(button)
        self.apply(button, { $0.existingButton(for: .normal) })
        self.apply(button, { $0.existingButton(for: setting.type) })
        
        return container
    }
    @objc func buttonClick(_ sender: UIButton) {
        self.buttons?[sender.tag].action?()
    }
    ///加载配置
    open func loadConfig<ReturnType>(_ action: (EasyAlertConfig) -> ReturnType) -> ReturnType{
        if let cfg = self.config {
            if cfg.isBaseOnDefault {
                _ = action(EasyAlertConfig.default)
            }
            return action(cfg)
        }else{
            return action(EasyAlertConfig.default)
        }
    }
    ///加载样式
    public func apply<ViewType: UIView>(_ view: ViewType, _ action: (EasyAlertConfig) -> EasyControlConfig<ViewType>?) {
        self.loadConfig { (config) -> Void in
            action(config)?.apply(for: view)
        }
    }
}
