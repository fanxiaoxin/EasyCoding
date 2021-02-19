//
//  Setting.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/30.
//

import UIKit

///整个框架通用的默认配置
public struct EasyControlSetting {
    ///颜色
    public struct Color {
        ///主色调
        public static var main: UIColor = .systemBlue
        ///浅色调
        public static var light: UIColor = .easy(0xbfbfbf)
        ///警告色
        public static var red: UIColor = .systemRed
        ///不可见色调
        public static var disabled: UIColor = .lightGray
        ///分割线
        public static var separator: UIColor = .easy(0xEFEFEF)
        ///文字颜色
        public static var text: UIColor = .easy(0x333333)
        ///文字颜色
        public static var darkText: UIColor = .easy(0x656565)
        ///文字颜色
        public static var lightText: UIColor = .easy(0x999999)
    }
    ///字体
    public struct Font {
        ///普通字体
        public static var normal: UIFont = UIFont.easy.pingfang(14)
        ///大字体
        public static var big: UIFont = UIFont.easy.pingfang(15)
        ///小字体
        public static var small: UIFont = UIFont.easy.pingfang(12)
    }
    ///常用的圆角
    public static var corner: CGFloat = 4
}
