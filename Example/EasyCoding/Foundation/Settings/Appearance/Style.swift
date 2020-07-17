//
//  Style.swift
//  YCP
//
//  Created by Fanxx on 2019/7/3.
//  Copyright © 2019 Ycp. All rights reserved.
//

import UIKit
import EasyCoding

///系统样式
struct Style {
    ///颜色
    struct Color {
        ///主色调
        static let main = UIColor.systemBlue
        //字体
        struct Font {
            ///字体主色调
            static let main = UIColor.easy(0x333333)
            ///字体主色调
            static let dark = UIColor.easy(0x666666)
            ///浅色调
            static let light = UIColor.easy(0x999999)
        }
    }
    ///用于字体适配屏幕的大小
    static var adaptWidth: CGFloat {
        return (min(UIScreen.main.bounds.size.width,UIScreen.main.bounds.size.height)/375)
    }
    ///用于字体适配屏幕的大小
    static func adapt(_ size: CGFloat,_ adapt: Bool = true) -> CGFloat {
        return adapt ? size * adaptWidth : size
    }
    ///配置公共UI，在APP加载完后调用
    static func load(){
        UINavigationBar.appearance().setBackgroundImage(UIImage.easy.color(.white), for: UIBarMetrics.default)
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = UIColor.easy(0x222222)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.easy(0x222222), NSAttributedString.Key.font: UIFont.bold(18, adapt: false)]
        //状态栏
        UINavigationBar.appearance().barStyle = .default
        //不显示最下边的线
        UINavigationBar.appearance().shadowImage = UIImage()
        
        //重写默认的数据视图
        ECSetting.DataPlugin.empty.viewBuilder = { DataEmptyView() }
        ECSetting.DataPlugin.loading.viewBuilder = { DataLoadingView() }
        ECSetting.DataPlugin.error.viewBuilder = { NetworkErrorView() }
        ECSetting.DataPlugin.headerBuilder = { RefreshHeader() }
        ECSetting.DataPlugin.footerBuilder = { RefreshFooter() }
    }
}
extension UIColor {
    static var main: UIColor {
        return Style.Color.main
    }
}
extension UILayoutPriority {
    ///可自适应尺寸 
    public static var resizeable: UILayoutPriority {
        return .init(1)
    }
}
extension UIFont {
    static func light(_ size: CGFloat, adapt: Bool = true) -> UIFont {
        return UIFont.easy.pingfang(light: Style.adapt(size, adapt))
    }
    static func regular(_ size: CGFloat, adapt: Bool = true) -> UIFont {
        return UIFont.easy.pingfang(Style.adapt(size, adapt))
    }
    static func medium(_ size: CGFloat, adapt: Bool = true) -> UIFont {
        return UIFont.easy.pingfang(medium: Style.adapt(size, adapt))
    }
    static func bold(_ size: CGFloat, adapt: Bool = true) -> UIFont {
        return UIFont.easy.pingfang(bold: Style.adapt(size, adapt))
    }
}
extension CGFloat {
    static var pixel: CGFloat {
        return CGFloat.easy.pixel
    }
    static func pixels(_ p: CGFloat) -> CGFloat {
        return CGFloat.easy.pixels(p)
    }
    static var safeTop:CGFloat{
        return UIView.easy.safeArea.top
    }
    static var safeBottom:CGFloat{
        return UIView.easy.safeArea.bottom
    }
}
