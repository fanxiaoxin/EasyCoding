//
//  SDWebImageStyle.swift
//  Alamofire
//
//  Created by Fanxx on 2019/8/20.
//

#if canImport(MJRefresh)
import UIKit
import MJRefresh

extension EasyStyleSetting where TargetType: UIScrollView {
    public static func mj_header(_ header: MJRefreshHeader) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.mj_header =  header
        })
    }
    public static func mj_footer(_ footer: MJRefreshFooter) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.mj_footer =  footer
        })
    }
}
#endif
