//
//  PagedControlStyle.swift
//  Alamofire
//
//  Created by Fanxx on 2019/7/8.
//

import UIKit

extension EasyStyleSetting where TargetType: UIPageControl {
    ///背景点颜色
    public static func color(_ color:UIColor?) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.pageIndicatorTintColor = color
        })
    }
    ///背景点颜色
    public static func color(rgb color:UInt32) -> EasyStyleSetting<TargetType> {
        return .color(UIColor.easy.rgb( color))
    }
    ///选中点颜色
    public static func current(color:UIColor?) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.currentPageIndicatorTintColor = color
        })
    }
    ///选中点颜色
    public static func current(rgb color:UInt32) -> EasyStyleSetting<TargetType> {
        return .color(UIColor.easy.rgb( color))
    }
    ///单页隐藏
    public static func hidesSingle(_ hides: Bool = true) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.hidesForSinglePage = hides
        })
    }
    ///页数
    public static func pages(_ count: Int) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.numberOfPages = count
        })
    }
    ///当前页码
    public static func current(_ current: Int) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.currentPage = current
        })
    }
    
}
