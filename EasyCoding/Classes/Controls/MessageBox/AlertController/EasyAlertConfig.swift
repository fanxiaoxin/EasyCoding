//
//  AlertViewConfig.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/19.
//

import UIKit

public class EasyAlertConfig {
    ///全局配置
    public static let `default` = Default()
    required public init() {
        
    }
    ///是否在全局配置的基础上覆盖，若为否则不加载全局配置，仅使用当前配置
    public var isBaseOnDefault: Bool = true
    
    ///背景
    public let background = EasyControlConfig<UIView>()
    ///最外围的视图
    public let container = EasyControlConfig<UIView>()
    ///最外围的视图
    public let containerStack = EasyControlConfig<UIStackView>()
    ///标题
    public let title = EasyControlConfig<EasyLabel>()
    ///标题跟内容的分隔线
    public let titleSeparator = EasyControlConfig<UIView>()
    ///内容容器，将需要显示的内容放在里面，一般为Label，也可自定义
    public let content = EasyControlConfig<UIScrollView>()
    ///内容跟按钮的分隔线
    public let contentSeparator = EasyControlConfig<UIView>()
    ///放置所有按钮的容器
    public let buttonContainer = EasyControlConfig<UIView>()
    ///放置所有按钮的容器
    public let buttonContainerStack = EasyControlConfig<UIStackView>()
    ///按钮之间的分隔线
    public let buttonSeparator = EasyControlConfig<UIView>()
    ///指定类型的按钮，未设置的以normal为主
    public var buttons:[EasyAlertView.ButtonType: EasyControlConfig<EasyButton>] = [:]
    ///默认的标题
    public var commonTitle: String?
    ///常见的按钮类型默认配置
    public var commonButtons:[EasyAlertController.CommonButtonType: EasyAlertController.Button] = [:]
    ///呈现动画
    public var presentAnimation: EasyPresentAnimationType?
    ///背景呈现动画
    public var backgroundPresentAnimation: EasyPresentAnimationType?
    
    ///默认的按钮样式
    public var button: EasyControlConfig<EasyButton> {
        return self.button(for: .normal)
    }
    ///指定类型的按钮，没有则生成
    public func button(for type: EasyAlertView.ButtonType) -> EasyControlConfig<EasyButton> {
        if let config = self.buttons[type] {
            return config
        }else{
            let config = EasyControlConfig<EasyButton>()
            self.buttons[type] = config
            return config
        }
    }
    ///已经存在指定类型的按钮，未设置的以normal为主，不会自动生成
    public func existingButton(for type: EasyAlertView.ButtonType) -> EasyControlConfig<EasyButton>? {
        return self.buttons[type]
    }
    ///配置默认样式
    public class Default: EasyAlertConfig {
        required init() {
            super.init()
            //背景透明
            self.background.style(.bg(.clear))
            //容器居中偏上
            self.container.style(.bg(.white) ,.corner(EasyControlSetting.corner), .border(EasyControlSetting.Color.separator))
            self.container.layout(.greather(.marginX(20)), .greather(.marginY(20)), .center)
            self.containerStack.style(.axis(.vertical), .alignment(.fill), .distribution(.fill))
            self.containerStack.layout(.margin)
            //标题
            self.title.style(.font(EasyControlSetting.Font.normal.easy.bold), .color(EasyControlSetting.Color.text), .lines(), .center)
            self.title.layout(.margin(20, 15, 5, 15))
            //标题跟内容的分隔线
            self.titleSeparator.style(.height(0), .bg(EasyControlSetting.Color.separator))
            self.titleSeparator.layout(.margin(10, 0))
            //内容容器，将需要显示的内容放在里面，一般为Label，也可自定义
            self.content.style(.width(250))
            self.content.layout(.margin)
            //内容跟按钮的分隔线
            self.contentSeparator.style(.height(CGFloat.easy.pixel), .bg(EasyControlSetting.Color.separator))
            self.contentSeparator.layout(.margin)
            //放置所有按钮的容器
            self.buttonContainer.style(.height(44))
            self.buttonContainer.layout(.margin)
            self.buttonContainerStack.style(.axis(.horizontal), .alignment(.fill), .distribution(.fill))
            self.buttonContainerStack.layout(.margin)
            //按钮之间的分隔线
            self.buttonSeparator.style(.width(CGFloat.easy.pixel), .bg(EasyControlSetting.Color.separator))
            self.buttonSeparator.layout(.margin(0, 8))
            //按钮
            self.button(for: .normal).layout(.margin)
            self.button(for: .normal).style(.color(EasyControlSetting.Color.text), .color(EasyControlSetting.Color.text.withAlphaComponent(0.4), for: .highlighted), .font(EasyControlSetting.Font.big))
            self.button(for: .negative).style(.color(EasyControlSetting.Color.darkText), .color(EasyControlSetting.Color.text.withAlphaComponent(0.4), for: .highlighted))
            self.button(for: .positive).style(.color(EasyControlSetting.Color.main), .color(EasyControlSetting.Color.main.withAlphaComponent(0.4), for: .highlighted), .font(EasyControlSetting.Font.big.easy.bold))
            self.button(for: .destructive).style(.color(EasyControlSetting.Color.red), .font(EasyControlSetting.Font.big.easy.bold))
            //默认标题
            self.commonTitle = nil
            //常见按钮
            self.commonButtons[.cancel] = EasyAlertController.Button(sizeRatio: 1, type: .negative, text: "取消", action: { (alert) in
                alert.dismiss()
            })
            self.commonButtons[.confirm] = EasyAlertController.Button(sizeRatio: 1, type: .positive, text: "确定", action:nil)
            //呈现动画
            self.presentAnimation = EasyPresentAnimation.Popup()
            //背景为透明所以不需要呈现动画
            self.backgroundPresentAnimation = nil
        }
    }
}

//将相关配置汇总起来
extension EasyControlSetting {
    ///弹窗全局配置
    public static var Alert: EasyAlertConfig { return EasyAlertConfig.default }
}
