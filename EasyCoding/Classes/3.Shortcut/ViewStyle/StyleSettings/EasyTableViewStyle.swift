//
//  TableViewStyle.swift
//  Alamofire
//
//  Created by Fanxx on 2019/7/17.
//

import UIKit

extension EasyStyleSetting where TargetType: UITableView {
    ///行高
    public static func row(height:CGFloat) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.rowHeight = height
            target.estimatedRowHeight = height
        })
    }
    ///自动行高
    public static func row(estimated height:CGFloat) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.estimatedRowHeight = height
            target.rowHeight = UITableView.automaticDimension
        })
    }
    ///Section头部高
    public static func sectionHeader(height:CGFloat) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.sectionHeaderHeight = height
            target.estimatedSectionHeaderHeight = height
        })
    }
    ///Section底部高
    public static func sectionFooter(height:CGFloat) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.sectionFooterHeight = height
            target.estimatedSectionFooterHeight = height
        })
    }
    ///分隔线样式
    public static func separator(_ style:UITableViewCell.SeparatorStyle, color:UIColor? = nil, insets: UIEdgeInsets? = nil) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.separatorStyle = style
            if let s = color { target.separatorColor = s }
            if let s = insets { target.separatorInset = s }
        })
    }
    ///选择
    public static func selection(_ allows:Bool = true) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.allowsSelection = allows
        })
    }
    ///选择
    public static func selection(multiple allows:Bool = true) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.allowsMultipleSelection = allows
        })
    }
    public static func header(_ view: UIView) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.tableHeaderView = view
        })
    }
    public static func footer(_ view: UIView) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.tableFooterView = view
        })
    }
    ///将底部置为空View，可清除多余的分隔线
    public static var emptyFooter: EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.tableFooterView = UIView()
        })
    }
    ///注册Cell缓存类型
    public static func cell(_ cls: AnyClass, identifier: String = .easyCellIdentifier) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.register(cls, forCellReuseIdentifier: identifier)
        })
    }
}
extension String {
    public static var easyCellIdentifier: String {
        return "EasyCodingCell"
    }
}
