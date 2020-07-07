//
//  ECToolbarKeyboard.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/7.
//

import UIKit

///底下弹出带工具栏的键盘，内容为空，使用需继承
open class ECToolbarKeyboard<InputType>: UIView, ECKeyboardType {
    open var inputReceive: ((InputType) -> Void)?
    ///工具栏
    public let toolbar = Toolbar()
    ///工具栏跟内容的分隔线
    public let toolbarSeparator = UIView()
    ///内容视图
    public let contentView = UIView()
    ///最外围的视图
    public let containerStack = UIStackView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.load()
    }
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.load()
    }
    open func load() {
        let toolbarContainer = UIView()
        let toolbarSeparatorContainer = UIView()
        let contentContainer = UIView()
        
        containerStack.easy.style(.views([toolbarContainer,
                                          toolbarSeparatorContainer,
                                          contentContainer].easy.style(.bg(.clear)).base))
        ECToolbarKeyboardConfig.default.background.apply(for: self)
        
        self.addSubview(containerStack)
        ECToolbarKeyboardConfig.default.containerStack.apply(for: containerStack)

        toolbarContainer.addSubview(self.toolbar)
        ECToolbarKeyboardConfig.default.toolbar.apply(for: self.toolbar)
        
        toolbarSeparatorContainer.addSubview(self.toolbarSeparator)
        ECToolbarKeyboardConfig.default.toolbarSeparator.apply(for: self.toolbarSeparator)
        
        contentContainer.addSubview(self.contentView)
        ECToolbarKeyboardConfig.default.content.apply(for: self.contentView)
        
        self.toolbar.cancelButton.addTarget(self, action: #selector(self.cancel), for: .touchUpInside)
        self.toolbar.confirmButton.addTarget(self, action: #selector(self.confirm), for: .touchUpInside)
    }
    ///获取当前值
    open func currentValue() -> InputType {
        fatalError("未实现")
    }
    @objc func cancel() {
        self.dismiss()
    }
    @objc func confirm() {
        self.input(self.currentValue())
        self.dismiss()
    }
    public class Toolbar: UIView {
        public let titleLabel = ECLabel()
        public let cancelButton = ECButton()
        public let confirmButton = ECButton()
        
        ///最外围的视图
        public let containerStack = UIStackView()
        
        public override init(frame: CGRect) {
             super.init(frame: frame)
             self.load()
         }
         required public init?(coder: NSCoder) {
             super.init(coder: coder)
             self.load()
         }
        open func load() {
            let titleContainer = UIView()
            let cancelContainer = UIView()
            let confirmContainer = UIView()
            
            containerStack.easy.style(.views([cancelContainer,
                                                titleContainer,
                                                confirmContainer].easy.style(.bg(.clear)).base))
            self.addSubview(containerStack)
            ECToolbarKeyboardConfig.default.toolbarStack.apply(for: containerStack)

            ///标题
            titleContainer.addSubview(self.titleLabel)
            ECToolbarKeyboardConfig.default.title.apply(for: self.titleLabel)
            ///取消
            cancelContainer.addSubview(self.cancelButton)
            ECToolbarKeyboardConfig.default.cancel.apply(for: self.cancelButton)
            ///确定
            confirmContainer.addSubview(self.confirmButton)
            ECToolbarKeyboardConfig.default.confirm.apply(for: self.confirmButton)
        }
    }
}

public class ECToolbarKeyboardConfig {
    ///全局配置
    public static let `default` = Default()
    required public init() {
        
    }
    ///背景
    public let background = ECControlConfig<UIView>()
    ///最外围的视图
    public let containerStack = ECControlConfig<UIStackView>()
    ///工具条
    public let toolbar = ECControlConfig<UIView>()
    ///工具条最外围的视图
    public let toolbarStack = ECControlConfig<UIStackView>()
    ///标题
    public let title = ECControlConfig<ECLabel>()
    ///取消按钮默认配置
    public let cancel = ECControlConfig<ECButton>()
    ///确认按钮默认配置
    public let confirm = ECControlConfig<ECButton>()
    
    ///工具栏跟内容的分隔线
    public let toolbarSeparator = ECControlConfig<UIView>()
    
    ///内容容器，将需要显示的内容放在里面，一般为Label，也可自定义
    public let content = ECControlConfig<UIView>()
    ///呈现动画
    public var presentAnimation: ECPresentAnimationType?
    ///配置默认样式
    public class Default: ECToolbarKeyboardConfig {
        required init() {
            super.init()
            //背景白色
            self.background.style(.bg(.white))
            //容器填充
            self.containerStack.style(.axis(.vertical), .alignment(.fill), .distribution(.fill))
            self.containerStack.layout(.margin)
            //工具条
            self.toolbar.style(.border(ECSetting.Color.separator))
            self.toolbar.layout(.margin(-1, 0), .height(44))
            self.toolbarStack.style(.axis(.horizontal), .alignment(.fill), .distribution(.fillProportionally))
            self.toolbarStack.layout(.margin)
            //标题
            self.title.style(.font(ECSetting.Font.normal.easy.bold), .color(ECSetting.Color.text), .lines(), .center)
            self.title.layout(.margin(5))
            //取消
            self.cancel.style(.text("取消"), .font(ECSetting.Font.big), .color(ECSetting.Color.darkText), .color(ECSetting.Color.text.withAlphaComponent(0.4), for: .highlighted), .align(.left))
            self.cancel.layout(.margin(0, 10, 0, 0), .width(60))
            //确认
            self.confirm.style(.text("确定"), .font(ECSetting.Font.big.easy.bold), .color(ECSetting.Color.main), .color(ECSetting.Color.main.withAlphaComponent(0.4), for: .highlighted), .align(.right))
            self.confirm.layout(.margin(0, 0, 0, 10), .width(60))
            //工具条跟内容的分隔线
            self.toolbarSeparator.style(.height(0), .bg(ECSetting.Color.separator))
            self.toolbarSeparator.layout(.margin(0, 0))
            //内容容器，将需要显示的内容放在里面
            self.content.layout(.margin)
        }
    }
}

//将相关配置汇总起来
extension ECSetting {
    ///工具栏键盘全局配置
    public static var ToolbarKeyboard: ECToolbarKeyboardConfig { return ECToolbarKeyboardConfig.default }
}
