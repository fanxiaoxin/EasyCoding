//
//  MessageBox.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/22.
//

import UIKit

///消息窗配置
public struct EasyMessageBoxConfig {
    ///消息内容
    public static let message = EasyControlConfig<EasyLabel>(styles: [.font(EasyControlSetting.Font.normal), .color(EasyControlSetting.Color.text), .lines(), .lowPriority()], layouts: [.margin(25, 15)])
    ///确认弹框的确认按钮位置，默认右边，(右下同义，左上同义)
    public static var confirmButtonDirection: EasyDirection = .right
    ///输入框
    public static let input = EasyControlConfig<EasyTextField>(styles: [.font(EasyControlSetting.Font.normal), .color(EasyControlSetting.Color.text), .lowPriority(), .height(44), .padding(.easy(x: 15, y: 0))], layouts: [.margin])
}
///扩展AlertConfig，简化使用复杂度，统一在AlertConfig里配置
extension EasyAlertConfig {
    public var message: EasyControlConfig<EasyLabel> {
        return EasyMessageBoxConfig.message
    }
    ///确认弹框的确认按钮位置，默认右边，(右下同义，左上同义)
    public var confirmButtonDirection: EasyDirection {
        get {
            return EasyMessageBoxConfig.confirmButtonDirection
        }
        set {
            EasyMessageBoxConfig.confirmButtonDirection = newValue
        }
    }
    ///输入框
    public var input: EasyControlConfig<EasyTextField> {
        return EasyMessageBoxConfig.input
    }
}

///一个高可定制性的消息弹窗
public struct EasyMessageBox {
    ///创建消息按钮
    private static func messageLabel(_ text: EasyControlTextType) -> UIView {
        let labelContainer = UIView()
        let label = EasyLabel()
        labelContainer.addSubview(label)
        EasyMessageBoxConfig.message.apply(for: label)
        text.setText(to: label)
        return labelContainer
    }
    ///自定义页面
    public static func alert(title: String? = EasyAlertConfig.default.commonTitle, contentView: UIView, buttons: [EasyAlertController.Button], config: EasyAlertConfig?, completion: (()->Void)? = nil) {
        let controller = EasyAlertController(title: title, contentView: contentView, buttons: buttons, config: config)
        controller.show(completion: completion)
    }
    ///自定义按钮弹窗
    public static func alert(title: String? = EasyAlertConfig.default.commonTitle, message: EasyControlTextType, buttons:[EasyAlertController.Button]) {
        self.alert(title: title, contentView: messageLabel(message), buttons: buttons, config: nil)
    }
    ///最普通的弹窗
    public static func alert(title: String? = EasyAlertConfig.default.commonTitle, attr message: EasyAttributedString,action: (() -> Void)? = nil) {
        self.alert(title: title, message: message, action: action)
    }
    ///最普通的弹窗
    public static func alert(title: String? = EasyAlertConfig.default.commonTitle, message: EasyControlTextType,action: (() -> Void)? = nil) {
        self.alert(title: title, message: message, buttons: [.confirm(action: { (alert) in
            alert.dismiss()
            action?()
        })])
    }
    ///确认框
    public static func confirm(title: String? = EasyAlertConfig.default.commonTitle, contentView: UIView, action: @escaping (EasyAlertController) -> Void, completion: (()->Void)? = nil) {
        let buttons: [EasyAlertController.Button]
        switch EasyMessageBoxConfig.confirmButtonDirection {
        case .top, .left:
            buttons = [.confirm(action: action), .cancel]
        default:
            buttons = [.cancel, .confirm(action: action)]
        }
        self.alert(title: title, contentView:contentView, buttons: buttons, config: nil, completion: completion)
    }
    ///确认框
    public static func confirm(title: String? = EasyAlertConfig.default.commonTitle, attr message: EasyAttributedString, action: @escaping () -> Void) {
        self.confirm(title: title, message: message, action: action)
    }
    ///确认框
    public static func confirm(title: String? = EasyAlertConfig.default.commonTitle, message: EasyControlTextType, action: @escaping () -> Void) {
        self.confirm(title: title, contentView: messageLabel(message), action: { (alert) in
            alert.dismiss()
            action()
        })
    }
    ///输入框
    @discardableResult
    public static func input(title: String, placeHolder: String, text: String? = nil, action: @escaping (EasyTextField) -> Void) -> EasyTextField {
        let inputContainer = UIView()
        let input = EasyTextField()
        inputContainer.addSubview(input)
        EasyMessageBoxConfig.input.apply(for: input)
        input.placeholder = placeHolder
        input.text = text
        self.confirm(title: title, contentView: inputContainer, action: { [weak input] alert in
            alert.dismiss()
            if let ip = input {
                action(ip)
            }
        }) { [weak input] in
            input?.becomeFirstResponder()
        }
        return input
    }
}
extension EasyMessageBox {
    ///自动消失的提示框
    public static func toast(_ message: String, completion: (()->Void)? = nil) {
        let toast = EasyToastView(message: message)
        toast.show(completion: completion)
    }
}
