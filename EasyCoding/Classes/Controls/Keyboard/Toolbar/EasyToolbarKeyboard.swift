//
//  EasyToolbarKeyboard.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/7.
//

import UIKit

///底下弹出带工具栏的键盘，内容为空，使用需继承
open class EasyToolbarKeyboard<InputType>: UIView, EasyKeyboardType, UIGestureRecognizerDelegate {
    ///点击背景区域自动关闭
    open var isHiddenForTouchBackground = false
    open var inputReceive: ((InputType) -> Void)?
    open lazy var actionForClose: () -> Void = { [weak self] in self?.dismiss() }
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
        EasyToolbarKeyboardConfig.default.background.apply(for: self)
        
        self.addSubview(containerStack)
        EasyToolbarKeyboardConfig.default.containerStack.apply(for: containerStack)

        toolbarContainer.addSubview(self.toolbar)
        EasyToolbarKeyboardConfig.default.toolbar.apply(for: self.toolbar)
        
        toolbarSeparatorContainer.addSubview(self.toolbarSeparator)
        EasyToolbarKeyboardConfig.default.toolbarSeparator.apply(for: self.toolbarSeparator)
        
        contentContainer.addSubview(self.contentView)
        EasyToolbarKeyboardConfig.default.content.apply(for: self.contentView)
        
        self.toolbar.cancelButton.addTarget(self, action: #selector(self.cancel), for: .touchUpInside)
        self.toolbar.confirmButton.addTarget(self, action: #selector(self.confirm), for: .touchUpInside)
    }
    ///获取当前值
    open func currentValue() -> InputType? {
        return nil
    }
    @objc func cancel() {
        self.actionForClose()
    }
    @objc func confirm() {
        if let value = self.currentValue() {
            self.input(value)
        }
        self.actionForClose()
    }
    public func show() {
        var frame = self.frame
        if frame.origin == .zero {
            frame.origin = self.defaultFrame.origin
        }
        if frame.size.width == 0 {
            frame.size.width = self.defaultFrame.size.width
        }
        if frame.size.height == 0 {
            frame.size.height = self.defaultFrame.size.height
        }
        self.frame = frame
        if self.isHiddenForTouchBackground {
            let view = UIView(frame: UIScreen.main.bounds)
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.cancel))
            tap.delegate = self
            view.addGestureRecognizer(tap)
            view.addSubview(self)
            view.easy.openWindow()
            self.easy.show(animation: EasyPresentAnimation.SlideOut(direction: .bottom))
        }else{
            self.easy.showWindow(animation: EasyPresentAnimation.SlideOut(direction: .bottom))
        }
    }
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == self.superview
    }
    public class Toolbar: UIView {
        public let titleLabel = EasyLabel()
        public let cancelButton = EasyButton()
        public let confirmButton = EasyButton()
        
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
            EasyToolbarKeyboardConfig.default.toolbarStack.apply(for: containerStack)

            ///标题
            titleContainer.addSubview(self.titleLabel)
            EasyToolbarKeyboardConfig.default.title.apply(for: self.titleLabel)
            ///取消
            cancelContainer.addSubview(self.cancelButton)
            EasyToolbarKeyboardConfig.default.cancel.apply(for: self.cancelButton)
            ///确定
            confirmContainer.addSubview(self.confirmButton)
            EasyToolbarKeyboardConfig.default.confirm.apply(for: self.confirmButton)
        }
    }
}

public class EasyToolbarKeyboardConfig {
    ///全局配置
    public static let `default` = Default()
    required public init() {
        
    }
    ///背景
    public let background = EasyControlConfig<UIView>()
    ///最外围的视图
    public let containerStack = EasyControlConfig<UIStackView>()
    ///工具条
    public let toolbar = EasyControlConfig<UIView>()
    ///工具条最外围的视图
    public let toolbarStack = EasyControlConfig<UIStackView>()
    ///标题
    public let title = EasyControlConfig<EasyLabel>()
    ///取消按钮默认配置
    public let cancel = EasyControlConfig<EasyButton>()
    ///确认按钮默认配置
    public let confirm = EasyControlConfig<EasyButton>()
    
    ///工具栏跟内容的分隔线
    public let toolbarSeparator = EasyControlConfig<UIView>()
    
    ///内容容器，将需要显示的内容放在里面，一般为Label，也可自定义
    public let content = EasyControlConfig<UIView>()
    ///呈现动画
    public var presentAnimation: EasyPresentAnimationType?
    ///配置默认样式
    public class Default: EasyToolbarKeyboardConfig {
        required init() {
            super.init()
            //背景白色
            self.background.style(.bg(.white))
            //容器填充
            self.containerStack.style(.axis(.vertical), .alignment(.fill), .distribution(.fill))
            self.containerStack.layout(.margin)
            //工具条
            self.toolbar.style(.border(EasyControlSetting.Color.separator))
            self.toolbar.layout(.margin(-1, 0), .height(44))
            self.toolbarStack.style(.axis(.horizontal), .alignment(.fill), .distribution(.fillProportionally))
            self.toolbarStack.layout(.margin)
            //标题
            self.title.style(.font(EasyControlSetting.Font.normal.easy.bold), .color(EasyControlSetting.Color.text), .lines(), .center)
            self.title.layout(.margin(5))
            //取消
            self.cancel.style(.text("取消"), .font(EasyControlSetting.Font.big), .color(EasyControlSetting.Color.darkText), .color(EasyControlSetting.Color.text.withAlphaComponent(0.4), for: .highlighted), .align(.left))
            self.cancel.layout(.margin(0, 10, 0, 0), .width(60))
            //确认
            self.confirm.style(.text("确定"), .font(EasyControlSetting.Font.big.easy.bold), .color(EasyControlSetting.Color.main), .color(EasyControlSetting.Color.main.withAlphaComponent(0.4), for: .highlighted), .align(.right))
            self.confirm.layout(.margin(0, 0, 0, 10), .width(60))
            //工具条跟内容的分隔线
            self.toolbarSeparator.style(.height(0), .bg(EasyControlSetting.Color.separator))
            self.toolbarSeparator.layout(.margin(0, 0))
            //内容容器，将需要显示的内容放在里面
            self.content.layout(.margin)
        }
    }
}

//将相关配置汇总起来
extension EasyControlSetting {
    ///工具栏键盘全局配置
    public static var ToolbarKeyboard: EasyToolbarKeyboardConfig { return EasyToolbarKeyboardConfig.default }
}
