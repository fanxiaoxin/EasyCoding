//
//  SDWebImageStyle.swift
//  Alamofire
//
//  Created by Fanxx on 2019/8/20.
//

import UIKit
import Kingfisher

extension ECStyleSetting where TargetType: UIButton {
    ///图片
    public static func kf(_ url:URL?, for state: UIControl.State = .normal) -> ECStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.kf.setImage(with: url, for: state)
        })
    } ///图片
    public static func kf(_ url:String?, for state: UIControl.State = .normal) -> ECStyleSetting<TargetType> {
        return .init(action: { (target) in
            if let u = url {
                target.kf.setImage(with: URL(string: u), for: state)
            }
        })
    }
    ///图片
    public static func kf(bg url:URL?, for state: UIControl.State = .normal) -> ECStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.kf.setBackgroundImage(with: url, for: state)
        })
    } ///图片
    public static func kf(bg url:String?, for state: UIControl.State = .normal) -> ECStyleSetting<TargetType> {
        return .init(action: { (target) in
            if let u = url {
                target.kf.setBackgroundImage(with: URL(string: u), for: state)
            }
        })
    }
}

extension ECStyleSetting where TargetType: UIImageView {
    ///图片
    public static func kf(_ url:URL?, completed: CompletionHandler? = nil) -> ECStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.kf.setImage(with: url, completionHandler: completed)
        })
    } ///图片
    public static func kf(_ url:String?, completed: CompletionHandler? = nil) -> ECStyleSetting<TargetType> {
        return .init(action: { (target) in
            if let u = url {
                target.kf.setImage(with: URL(string: u), completionHandler: completed)
            }
        })
    }
}
