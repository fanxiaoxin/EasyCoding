//
//  EasyPopupKeyboard.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/8.
//

import UIKit

///在指定位置弹出的键盘，内容为空，使用需继承
open class EasyPopupKeyboard<InputType>: UIView, EasyKeyboardType, UIGestureRecognizerDelegate {
    open var inputReceive: ((InputType) -> Void)?
    
    ///从指定位置弹出
    open var fromPosition: CGRect
    ///弹出尺寸会自动计划不超过屏幕及最大尺寸
    open var maxSize: CGSize = .easy(120, 260)
    ///默认从上往，从左往右弹出，若尺寸不够放且低于该尺寸则反方向弹出
    open var minSize: CGSize = .easy(120, 260)
    ///是否要设置为keyWindow，若包含输入框则需要设为true
    open var makeKey: Bool = false
    ///子类重载把控件添加到该视图
    public let contentView =  UIView()
    
    ///从指定位置的尺寸
    public init(from position: CGRect) {
        self.fromPosition = position
        super.init(frame: .zero)
        self.privateLoad()
    }
    ///从指定控件弹出
    public convenience init(from control: UIView) {
        let position = control.convert(control.bounds, to: control.window)
        self.init(from: position)
    }
    ///从指定点弹出
    public convenience init(from point: CGPoint) {
        let position = CGRect(origin: point, size: .zero)
        self.init(from: position)
    }
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func privateLoad() {
        ///添加内容控件
        self.addSubview(contentView)
        
        ///点击关闭事件
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.close))
        tap.delegate = self
        self.addGestureRecognizer(tap)
        
        self.load()
    }
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == self
    }
    @objc func close() {
        self.dismiss()
    }
    
    ///子类继承该方法在里面添加视图
    open func load() {
        
    }
    
    open func show() {
        self.easy.openWindow(makeKey: self.makeKey, useOwnFrame: false)
        //计算弹出位置及弹出点
        let rect = self.fromPosition
        let screen = UIScreen.main.bounds.size
        //默认右下
        var frame = CGRect(origin: .easy(rect.origin.x, rect.origin.y + rect.size.height), size: self.maxSize)
        var anchor = CGPoint(x: 0, y: 0)
        //超出宽度
        if frame.origin.x + frame.size.width > screen.width {
            //缩小宽度都不行则换到左侧
            if frame.origin.x + self.minSize.width > screen.width {
                frame.origin.x = max(0, rect.origin.x + rect.size.width - frame.size.width)
                if frame.origin.x == 0 {
                    ///若还撑开了则缩小宽度
                    frame.size.width = max(self.minSize.width, rect.origin.x + rect.size.width)
                }
                anchor.x = 1
            }else{
                //缩小宽度可以则缩小宽度
                frame.size.width = screen.width - frame.origin.x
//                anchor.x = max(1, rect.size.width / frame.size.width) * 0.5
            }
        }
        //超出高度
        if frame.origin.y + frame.size.height > screen.height {
            //缩小高度都不行则换到上侧
            if frame.origin.y + self.minSize.height > screen.height {
                frame.origin.y = max(0, rect.origin.y - frame.size.height)
                if frame.origin.x == 0 {
                    ///若还撑开了则缩小高度
                    frame.size.height = max(self.minSize.height, rect.origin.y)
                }
                anchor.y = 1
            }else{
                //缩小高度可以则缩小高度
                frame.size.height = screen.height - frame.origin.y
            }
        }

//        let startScale = CGPoint(x: max(min(1, rect.size.width / frame.size.width), 0.01), y: 0.01)
        let startScale = CGPoint(x: (rect.size.width / frame.size.width).easy.between(1, 0.01), y: 0.01)
        self.contentView.frame = frame
        self.contentView.easy.show(animation: EasyPresentAnimation.Popup(anchor: anchor, startScale: startScale))
    }
    open func dismiss() {
        self.contentView.easy.dismiss { [weak self] in
            self?.easy.closeWindow()
        }
    }
}
