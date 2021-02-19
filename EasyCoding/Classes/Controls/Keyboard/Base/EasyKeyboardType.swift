//
//  EasyKeyboardType.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/7.
//

import UIKit

///键盘
public protocol EasyKeyboardType: UIView {
    ///输入类型
    associatedtype InputType
    ///接收输入值
    var inputReceive: ((InputType) -> Void)? { get set }
    ///手动显示，若要做为TextField或TextView的输入则直接设置为控件的inputView属性即可，不需要手动调用
    func show()
    ///手动隐藏
    func dismiss()
}
extension EasyKeyboardType {
    ///输入值
    public func input(_ value: InputType) {
        self.inputReceive?(value)
    }
    ///键盘默认尺寸默认width = 屏幕宽度, height = 260
    public var defaultFrame: CGRect { return .easy(0, UIScreen.main.bounds.size.height - 260, UIScreen.main.bounds.size.width, 260) }
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
        self.easy.showWindow(animation: EasyPresentAnimation.SlideOut(direction: .bottom))
    }
    public func dismiss() {
        self.easy.dismissWindow()
    }
}
