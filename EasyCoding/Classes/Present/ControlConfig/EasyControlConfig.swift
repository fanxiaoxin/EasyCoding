//
//  ControlConfig.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/19.
//

import UIKit

///用于配置控件的样式，参考EasyAlertView
open class EasyControlConfig<ViewType: UIView> {
    private var styles : [EasyStyleSetting<ViewType>]
    private var layouts: [EasyViewLayout]
    
    public init() {
        self.styles = []
        self.layouts = []
    }
    public init(styles: [EasyStyleSetting<ViewType>], layouts: [EasyViewLayout]) {
        self.styles = styles
        self.layouts = layouts
    }
    
    ///重设样式
    @discardableResult
    public func style(_ styles: EasyStyleSetting<ViewType>...) -> Self {
        self.styles = styles
         return self
    }
    ///重设布局
    @discardableResult
    public func layout(_ layouts: EasyViewLayout...) -> Self {
        self.layouts = layouts
        return self
    }
    ///添加样式
    @discardableResult
    public func addStyle(_ styles: EasyStyleSetting<ViewType>...) -> Self {
        self.styles.append(contentsOf: styles)
        return self
    }
    ///添加布局
    @discardableResult
    public func addLayout(_ layouts: EasyViewLayout...) -> Self {
        self.layouts.append(contentsOf: layouts)
        return self
    }
    ///应用样式
    ///其中layout会布局到相对父视图
    public func apply(for view: ViewType) {
        self.styles.forEach({ $0.action(view) })
        if let sp = view.superview {
            self.layouts.forEach({ $0.apply(to: sp, with: view)})
        }
    }
}

