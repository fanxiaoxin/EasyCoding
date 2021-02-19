//
//  BundleExtension.swift
//  Alamofire
//
//  Created by Fanxx on 2019/8/1.
//

import UIKit


extension EasyCoding where Base : Bundle {
    ///对外版本号
    public var version: String {
        return self.base.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    ///构建版本号
    public var buildVersion: String {
        return self.base.infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
    ///Swift的命名空间
    public var namespace: String {
        return self.base.infoDictionary?["CFBundleExecutable"] as? String ?? ""
    }
}
//extension Bundle {
//    ///获取easyCoding的bundle
//    public static var easyCoding: Bundle {
//        guard let url = Bundle(for: EasyAttributedString.self).url(forResource: "EasyCoding", withExtension: "bundle"), let bundle = Bundle(url: url) else {
//            return .main
//        }
//        return bundle
//    }
//}
