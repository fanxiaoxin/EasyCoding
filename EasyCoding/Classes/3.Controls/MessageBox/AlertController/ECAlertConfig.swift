//
//  AlertViewConfig.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/19.
//

import UIKit

public class ECAlertConfig {
    ///全局配置
    public static let `default` = Default()
    required public init() {
        
    }
    ///是否在全局配置的基础上覆盖，若为否则不加载全局配置，仅使用当前配置
    public var isBaseOnDefault: Bool = true
    
    ///背景
    public let background = ECControlConfig<UIView>()
    ///最外围的视图
    public let container = ECControlConfig<UIView>()
    ///最外围的视图
    public let containerStack = ECControlConfig<UIStackView>()
    ///标题
    public let title = ECControlConfig<ECLabel>()
    ///标题跟内容的分隔线
    public let titleSeparator = ECControlConfig<UIView>()
    ///内容容器，将需要显示的内容放在里面，一般为Label，也可自定义
    public let content = ECControlConfig<UIScrollView>()
    ///内容跟按钮的分隔线
    public let contentSeparator = ECControlConfig<UIView>()
    ///放置所有按钮的容器
    public let buttonContainer = ECControlConfig<UIView>()
    ///放置所有按钮的容器
    public let buttonContainerStack = ECControlConfig<UIStackView>()
    ///按钮之间的分隔线
    public let buttonSeparator = ECControlConfig<UIView>()
    ///指定类型的按钮，未设置的以normal为主
    public var buttons:[ECAlertView.ButtonType: ECControlConfig<ECButton>] = [:]
    ///默认的标题
    public var commonTitle: String?
    ///常见的按钮类型默认配置
    public var commonButtons:[ECAlertController.CommonButtonType: ECAlertController.Button] = [:]
    ///呈现动画
    public var presentAnimation: ECPresentAnimationType?
    ///背景呈现动画
    public var backgroundPresentAnimation: ECPresentAnimationType?
    
    ///默认的按钮样式
    public var button: ECControlConfig<ECButton> {
        return self.button(for: .normal)
    }
    ///指定类型的按钮，没有则生成
    public func button(for type: ECAlertView.ButtonType) -> ECControlConfig<ECButton> {
        if let config = self.buttons[type] {
            return config
        }else{
            let config = ECControlConfig<ECButton>()
            self.buttons[type] = config
            return config
        }
    }
    ///已经存在指定类型的按钮，未设置的以normal为主，不会自动生成
    public func existingButton(for type: ECAlertView.ButtonType) -> ECControlConfig<ECButton>? {
        return self.buttons[type]
    }
    ///配置默认样式
    public class Default: ECAlertConfig {
        required init() {
            super.init()
            //背景透明
            self.background.style(.bg(.clear))
            //容器居中偏上
            self.container.style(.bg(.white) ,.corner(ECSetting.corner), .border(ECSetting.Color.separator))
            self.container.layout(.greather(.marginX(20)), .greather(.marginY(20)), .center)
            self.containerStack.style(.axis(.vertical), .alignment(.fill), .distribution(.fill))
            self.containerStack.layout(.margin)
            //标题
            self.title.style(.font(ECSetting.Font.normal.easy.bold), .color(ECSetting.Color.text), .lines(), .center)
            self.title.layout(.margin(20, 15, 5, 15))
            //标题跟内容的分隔线
            self.titleSeparator.style(.height(0), .bg(ECSetting.Color.separator))
            self.titleSeparator.layout(.margin(10, 0))
            //内容容器，将需要显示的内容放在里面，一般为Label，也可自定义
            self.content.style(.width(250))
            self.content.layout(.margin)
            //内容跟按钮的分隔线
            self.contentSeparator.style(.height(CGFloat.easy.pixel), .bg(ECSetting.Color.separator))
            self.contentSeparator.layout(.margin)
            //放置所有按钮的容器
            self.buttonContainer.style(.height(44))
            self.buttonContainer.layout(.margin)
            self.buttonContainerStack.style(.axis(.horizontal), .alignment(.fill), .distribution(.fill))
            self.buttonContainerStack.layout(.margin)
            //按钮之间的分隔线
            self.buttonSeparator.style(.width(CGFloat.easy.pixel), .bg(ECSetting.Color.separator))
            self.buttonSeparator.layout(.margin(0, 8))
            //按钮
            self.button(for: .normal).layout(.margin)
            self.button(for: .normal).style(.color(ECSetting.Color.text), .color(ECSetting.Color.text.withAlphaComponent(0.4), for: .highlighted), .font(ECSetting.Font.big))
            self.button(for: .negative).style(.color(ECSetting.Color.darkText), .color(ECSetting.Color.text.withAlphaComponent(0.4), for: .highlighted))
            self.button(for: .positive).style(.color(ECSetting.Color.main), .color(ECSetting.Color.main.withAlphaComponent(0.4), for: .highlighted), .font(ECSetting.Font.big.easy.bold))
            self.button(for: .destructive).style(.color(ECSetting.Color.red), .font(ECSetting.Font.big.easy.bold))
            //默认标题
            self.commonTitle = nil
            //常见按钮
            self.commonButtons[.cancel] = ECAlertController.Button(sizeRatio: 1, type: .negative, text: "取消", action: { (alert) in
                alert.dismiss()
            })
            self.commonButtons[.confirm] = ECAlertController.Button(sizeRatio: 1, type: .positive, text: "确定", action:nil)
            //呈现动画
            self.presentAnimation = ECPresentAnimation.Popup()
            //背景为透明所以不需要呈现动画
            self.backgroundPresentAnimation = nil
        }
    }
}

//将相关配置汇总起来
extension ECSetting {
    ///弹窗全局配置
    public static var Alert: ECAlertConfig { return ECAlertConfig.default }
}
