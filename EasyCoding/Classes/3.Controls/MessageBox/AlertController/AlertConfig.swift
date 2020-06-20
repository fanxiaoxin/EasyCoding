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
    public let title = ECControlConfig<UILabel>()
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
    ///显示动画
    public var animationForShow: ((ECAlertView) -> Void)?
    ///关闭动画，执行完需调用第二个参数回调
    public var animationForDismiss: ((ECAlertView, @escaping () -> Void) -> Void)?
    
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
            self.container.style(.bg(.white) ,.corner(4))
            self.container.layout(.greather(.marginX(10)), .greather(.marginY(10)), .centerX, .centerY(-50))
            self.containerStack.style(.axis(.vertical), .alignment(.fill), .distribution(.fill))
            self.containerStack.layout(.margin)
            //标题
            self.title.style(.boldFont(size: 14), .color(.black), .lines(), .center)
            self.title.layout(.margin(20))
            //标题跟内容的分隔线
            self.titleSeparator.style(.height(0), .bg(rgb: 0xEFEFEF))
            self.titleSeparator.layout(.margin(10, 0))
            //内容容器，将需要显示的内容放在里面，一般为Label，也可自定义
            self.content.style(.width(250))
            self.content.layout(.margin)
            //内容跟按钮的分隔线
            self.contentSeparator.style(.height(CGFloat.easy.pixel), .bg(rgb: 0xEFEFEF))
            self.contentSeparator.layout(.margin)
            //放置所有按钮的容器
            self.buttonContainer.style(.height(44))
            self.buttonContainer.layout(.margin)
            self.buttonContainerStack.style(.axis(.horizontal), .alignment(.fill), .distribution(.fill))
            self.buttonContainerStack.layout(.margin)
            //按钮之间的分隔线
            self.buttonSeparator.style(.width(CGFloat.easy.pixel), .bg(rgb: 0xEFEFEF))
            self.buttonSeparator.layout(.margin(0, 8))
            //按钮
            self.button(for: .normal).layout(.margin)
            self.button(for: .normal).style(.color(rgb: 0x333333), .color(UIColor.easy.rgb(0x333333, alpha: 0.4), for: .highlighted), .font(size: 15))
            self.button(for: .negative).style(.color(rgb: 0x656565), .color(.darkText, for: .highlighted))
            self.button(for: .positive).style(.color(rgb: 0x2D6DE1), .color(UIColor.easy.rgb(0x2D6DE1, alpha: 0.4), for: .highlighted), .boldFont(size: 15))
            self.button(for: .destructive).style(.color(.systemRed), .boldFont(size: 15))
            //显示动画
            self.animationForShow = { view in
                view.container.alpha = 0
                UIView.animate(withDuration: 0.25) {
                    view.container.alpha = 1
                }
            }
            //关闭动画
            self.animationForDismiss = { view, completion in
                UIView.animate(withDuration: 0.25, animations: {
                    view.container.alpha = 0
                }) { (_) in
                    completion()
                }
            }
        }
    }
}
