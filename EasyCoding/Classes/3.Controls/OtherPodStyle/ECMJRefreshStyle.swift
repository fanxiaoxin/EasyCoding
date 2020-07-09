//
//  SDWebImageStyle.swift
//  Alamofire
//
//  Created by Fanxx on 2019/8/20.
//

import UIKit
import MJRefresh

extension ECStyleSetting where TargetType: UIScrollView {
    public static func mj_header(_ header: MJRefreshHeader) -> ECStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.mj_header =  header
        })
    }
    public static func mj_footer(_ footer: MJRefreshFooter) -> ECStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.mj_footer =  footer
        })
    }
}
