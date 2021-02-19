//
//  ActivityIndicatorViewStyle.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/17.
//

import UIKit

extension EasyStyleSetting where TargetType: UIActivityIndicatorView {
    ///菊花样式
    public static func style(_ style:UIActivityIndicatorView.Style) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.style = style
        })
    }
    ///菊花颜色
    public static func color(_ color:UIColor) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.color = color
        })
    }
    ///菊花颜色
    public static func color(rgb color:UInt32) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.color = UIColor.easy.rgb(color)
        })
    }
    ///是否自动停止
    public static func hidesWhenStopped(_ hidesWhenStopped:Bool = true) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.hidesWhenStopped = hidesWhenStopped
        })
    }
    ///调用启动动画方法，需要保持启动时可直接设置
    public static func start() -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.startAnimating()
        })
    }
}
