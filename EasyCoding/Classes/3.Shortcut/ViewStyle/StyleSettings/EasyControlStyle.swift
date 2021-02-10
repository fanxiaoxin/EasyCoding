//
//  ControlStyle.swift
//  Alamofire
//
//  Created by Fanxx on 2019/7/16.
//

import UIKit

extension EasyStyleSetting where TargetType: UIControl {
    ///事件
    public static func event(_ target:Any?, _ action: Selector, for event: UIControl.Event = .touchUpInside) -> EasyStyleSetting<TargetType> {
        return .init(action: { (obj) in
            obj.addTarget(target, action: action, for: event)
        })
    }
    ///事件
    public static func valueChanged(_ target:Any?, _ action: Selector) -> EasyStyleSetting<TargetType> {
        return event(target, action, for: .valueChanged)
    }
    ///事件
    public static func editing(_ target:Any?, _ action: Selector) -> EasyStyleSetting<TargetType> {
        return event(target, action, for: .editingChanged)
    }
    ///事件
    public static func tap(_ target:Any?, _ action: Selector) -> EasyStyleSetting<TargetType> {
        return event(target, action, for: .touchUpInside)
    }
}
