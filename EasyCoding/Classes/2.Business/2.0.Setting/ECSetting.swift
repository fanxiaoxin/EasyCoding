//
//  Setting.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/30.
//

import UIKit

///整个框架通用的默认配置
public struct ECSetting {
    ///颜色
    public struct Color {
        ///主色调
        public static var main: UIColor = .systemBlue
        ///浅色调
        public static var light: UIColor = .easy(0xbfbfbf)
        ///不可见色调
        public static var disabled: UIColor = .lightGray
    }
    ///字体
    public struct Font {
        ///普通字体
        public static var normal: UIFont = .systemFont(ofSize: 14)
        ///大字体
        public static var big: UIFont = .systemFont(ofSize: 15)
        ///小字体
        public static var small: UIFont = .systemFont(ofSize: 12)
    }
}
