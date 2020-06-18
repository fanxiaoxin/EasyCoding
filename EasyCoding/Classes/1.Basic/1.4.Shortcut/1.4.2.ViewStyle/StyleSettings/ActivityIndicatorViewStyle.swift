//
//  ActivityIndicatorViewStyle.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/17.
//

import UIKit

extension ECStyleSetting where TargetType: UIActivityIndicatorView {
    ///菊花样式
    public static func style(_ style:UIActivityIndicatorView.Style) -> ECStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.style = style
        })
    }
    ///菊花颜色
    public static func color(_ color:UIColor) -> ECStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.color = color
        })
    }
    ///菊花颜色
    public static func color(rgb color:UInt32) -> ECStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.color = UIColor.easy.rgb(color)
        })
    }
    ///是否自动停止
    public static func hidesWhenStopped(_ hidesWhenStopped:Bool = true) -> ECStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.hidesWhenStopped = hidesWhenStopped
        })
    }
    ///调用启动动画方法，需要保持启动时可直接设置
    public static func start() -> ECStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.startAnimating()
        })
    }
}
