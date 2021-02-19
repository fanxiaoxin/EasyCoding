//
//  SDWebImageStyle.swift
//  Alamofire
//
//  Created by Fanxx on 2019/8/20.
//

#if canImport(Kingfisher)
import UIKit
import Kingfisher

extension EasyStyleSetting where TargetType: UIButton {
    ///图片
    public static func kf(_ url:URL?, for state: UIControl.State = .normal) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.kf.setImage(with: url, for: state)
        })
    } ///图片
    public static func kf(_ url:String?, for state: UIControl.State = .normal) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            if let u = url {
                target.kf.setImage(with: URL(string: u), for: state)
            }
        })
    }
    ///图片
    public static func kf(bg url:URL?, for state: UIControl.State = .normal) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.kf.setBackgroundImage(with: url, for: state)
        })
    } ///图片
    public static func kf(bg url:String?, for state: UIControl.State = .normal) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            if let u = url {
                target.kf.setBackgroundImage(with: URL(string: u), for: state)
            }
        })
    }
}

extension EasyStyleSetting where TargetType: UIImageView {
    ///图片
    public static func kf(_ url:URL?, completed: ((Result<RetrieveImageResult, KingfisherError>)->Void)? = nil) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.kf.setImage(with: url, completionHandler: completed)
        })
    } ///图片
    public static func kf(_ url:String?, completed: ((Result<RetrieveImageResult, KingfisherError>)->Void)? = nil) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            if let u = url {
                target.kf.setImage(with: URL(string: u), completionHandler: completed)
            }
        })
    }
}

#endif
