//
//  MessageBox.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/22.
//

import UIKit

///消息窗配置
public struct ECMessageBoxConfig {
    ///消息内容
    public static let message = ECControlConfig<ECLabel>(styles: [.font(ECSetting.Font.normal), .color(ECSetting.Color.text), .lines(), .lowPriority()], layouts: [.margin(25, 15)])
    ///确认弹框的确认按钮位置，默认右边，(右下同义，左上同义)
    public static var confirmButtonDirection: ECDirection = .right
    ///输入框
    public static let input = ECControlConfig<ECTextField>(styles: [.font(ECSetting.Font.normal), .color(ECSetting.Color.text), .lowPriority(), .height(44), .padding(.easy(x: 15, y: 0))], layouts: [.margin])
}
///扩展AlertConfig，简化使用复杂度，统一在AlertConfig里配置
extension ECAlertConfig {
    public var message: ECControlConfig<ECLabel> {
        return ECMessageBoxConfig.message
    }
    ///确认弹框的确认按钮位置，默认右边，(右下同义，左上同义)
    public var confirmButtonDirection: ECDirection {
        get {
            return ECMessageBoxConfig.confirmButtonDirection
        }
        set {
            ECMessageBoxConfig.confirmButtonDirection = newValue
        }
    }
    ///输入框
    public var input: ECControlConfig<ECTextField> {
        return ECMessageBoxConfig.input
    }
}

///一个高可定制性的消息弹窗
public struct ECMessageBox {
    ///创建消息按钮
    private static func messageLabel(_ text: ECControlTextType) -> UIView {
        let labelContainer = UIView()
        let label = ECLabel()
        labelContainer.addSubview(label)
        ECMessageBoxConfig.message.apply(for: label)
        text.setText(to: label)
        return labelContainer
    }
    ///自定义页面
    public static func alert(title: String? = ECAlertConfig.default.commonTitle, contentView: UIView, buttons: [ECAlertController.Button], config: ECAlertConfig?, completion: (()->Void)? = nil) {
        let controller = ECAlertController(title: title, contentView: contentView, buttons: buttons, config: config)
        controller.show(completion: completion)
    }
    ///自定义按钮弹窗
    public static func alert(title: String? = ECAlertConfig.default.commonTitle, message: ECControlTextType, buttons:[ECAlertController.Button]) {
        self.alert(title: title, contentView: messageLabel(message), buttons: buttons, config: nil)
    }
    ///最普通的弹窗
    public static func alert(title: String? = ECAlertConfig.default.commonTitle, attr message: ECAttributedString,action: (() -> Void)? = nil) {
        self.alert(title: title, message: message, action: action)
    }
    ///最普通的弹窗
    public static func alert(title: String? = ECAlertConfig.default.commonTitle, message: ECControlTextType,action: (() -> Void)? = nil) {
        self.alert(title: title, message: message, buttons: [.confirm(action: { (alert) in
            alert.dismiss()
            action?()
        })])
    }
    ///确认框
    public static func confirm(title: String? = ECAlertConfig.default.commonTitle, contentView: UIView, action: @escaping (ECAlertController) -> Void, completion: (()->Void)? = nil) {
        let buttons: [ECAlertController.Button]
        switch ECMessageBoxConfig.confirmButtonDirection {
        case .top, .left:
            buttons = [.confirm(action: action), .cancel]
        default:
            buttons = [.cancel, .confirm(action: action)]
        }
        self.alert(title: title, contentView:contentView, buttons: buttons, config: nil, completion: completion)
    }
    ///确认框
    public static func confirm(title: String? = ECAlertConfig.default.commonTitle, attr message: ECAttributedString, action: @escaping () -> Void) {
        self.confirm(title: title, message: message, action: action)
    }
    ///确认框
    public static func confirm(title: String? = ECAlertConfig.default.commonTitle, message: ECControlTextType, action: @escaping () -> Void) {
        self.confirm(title: title, contentView: messageLabel(message), action: { (alert) in
            alert.dismiss()
            action()
        })
    }
    ///输入框
    @discardableResult
    public static func input(title: String, placeHolder: String, text: String? = nil, action: @escaping (ECTextField) -> Void) -> ECTextField {
        let inputContainer = UIView()
        let input = ECTextField()
        inputContainer.addSubview(input)
        ECMessageBoxConfig.input.apply(for: input)
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
extension ECMessageBox {
    ///自动消失的提示框
    public static func toast(_ message: String, completion: (()->Void)? = nil) {
        let toast = ECToastView(message: message)
        toast.show(completion: completion)
    }
}
