//
//  SliderStyle.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/17.
//

import UIKit

extension EasyStyleSetting where TargetType: UISlider {
    ///当前值
    public static func value(_ value:Float) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.value = value
        })
    }
    ///最小值
    public static func min(_ value:Float) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.minimumValue = value
        })
    }
    ///最大值
    public static func max(_ value:Float) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.maximumValue = value
        })
    }
    ///最小值图片
    public static func min(image:UIImage) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.minimumValueImage = image
        })
    }
    ///最小值图片
    public static func min(image:String) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.minimumValueImage = UIImage(named: image)
        })
    }
    ///最大值图片
    public static func max(image:UIImage) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.maximumValueImage = image
        })
    }
    ///最大值图片
    public static func max(image:String) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.maximumValueImage = UIImage(named: image)
        })
    }
    ///设置事件是否连续触发
    public static func continuous(_ value:Bool) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.isContinuous = value
        })
    }
    ///进度条左边的颜色
    public static func min(color:UIColor) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.minimumTrackTintColor = color
        })
    }
    ///进度条左边的颜色
    public static func min(rgb color:UInt32) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.minimumTrackTintColor = UIColor.easy.rgb(color)
        })
    }
    ///进度条右边的颜色
    public static func max(color:UIColor) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.maximumTrackTintColor = color
        })
    }
    ///进度条右边的颜色
    public static func max(rgb color:UInt32) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.maximumTrackTintColor = UIColor.easy.rgb(color)
        })
    }
    ///进度值的颜色
    public static func thumb(color:UIColor) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.thumbTintColor = color
        })
    }
    ///进度值的颜色
    public static func thumb(rgb color:UInt32) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.thumbTintColor = UIColor.easy.rgb(color)
        })
    }
    ///进度值的图片
    public static func thumb(image:UIImage, for state: UIControl.State = .normal) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.setThumbImage(image, for: state)
        })
    }
    ///进度值的图片
    public static func thumb(image:String, for state: UIControl.State = .normal) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.setThumbImage(UIImage(named: image), for: state)
        })
    }
    ///最小值的图片
    public static func min(image:UIImage, for state: UIControl.State = .normal) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.setMinimumTrackImage(image, for: state)
        })
    }
    ///最小值的图片
    public static func min(image:String, for state: UIControl.State = .normal) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.setMinimumTrackImage(UIImage(named: image), for: state)
        })
    }
    ///最大值的图片
    public static func max(image:UIImage, for state: UIControl.State = .normal) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.setMaximumTrackImage(image, for: state)
        })
    }
    ///最大值的图片
    public static func max(image:String, for state: UIControl.State = .normal) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.setMaximumTrackImage(UIImage(named: image), for: state)
        })
    }
}
