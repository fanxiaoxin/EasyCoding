//
//  EasyBadge.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/9/9.
//

import UIKit

///BadgeTag索引
fileprivate let __ecBadgeTagStartIndex = 888
///角标
public enum EasyBadge {
    ///角标位置
    public enum Position {
        ///右上角
        case rightTop(_ right: CGFloat, _ top: CGFloat)
        ///左上角
        case leftTop(_ left: CGFloat, _ top: CGFloat)
        ///左下角
        case leftBottom(_ left: CGFloat, _ bottom: CGFloat)
        ///右下角
        case rightBottom(_ right: CGFloat, _ bottom: CGFloat)
    }
    ///清除
    case none
    ///设置视图，frame为相对于中心偏移的位置(默认为右上角, 如tabBar则为标准图标大小(25 x 25)的右上角)，圆角和大小需要自己设置
    case view(_ view:UIView, position: Position)
}
public extension EasyBadge {
    ///设置视图，frame为相对于中心偏移的位置(默认为右上角, 如tabBar则为标准图标大小(25 x 25)的右上角)，圆角和大小需要自己设置
    static func view(_ view:UIView)-> Self {
        return .view(view, position: .rightTop(0, 0))
    }
    ///Label
    static func label(position: Position = .rightTop(0, 0), style: EasyStyleSetting<EasyLabel>...) -> Self {
        return .view(EasyLabel.easy(styles: style), position: position)
    }
    ///数量
    static func value(_ value: Int, font size: CGFloat = 10, color: UIColor = .systemRed, position: Position = .rightTop(0, 5), style: EasyStyleSetting<EasyLabel>...) -> Self {
        let label = EasyLabel.easy(.text(value.description), .font(size: size), .bg(color), .color(.white), .padding(.easy(x: 3, y: 1)))
        label.easy(styles: style)
        let size = label.sizeThatFits(.zero)
        label.easy(.corner(size.height / 2))
        return .view(label, position: position)
    }
    ///小红点
    static func point(color: UIColor = .systemRed, size: CGFloat = 8, position: Position = .rightTop(0, 2)) -> Self {
        return .view(UIView.easy(.bg(color), .size(size), .corner(size / 2)), position: position)
    }
}
extension EasyBadge {
    ///设置到指定TabBar，只能设置竖起方向
    public func set(for tabBar: UITabBar, at index: Int) {
        switch self {
        case .none:
            self.remove(for: tabBar, tag: index)
        case let .view(badge, position: position):
            self.remove(for: tabBar, tag: index)
            let x = CGFloat(index * 2 + 1) / CGFloat(tabBar.items?.count ?? 1)
            let y: CGFloat = 17 / 24.5
            let offset: CGPoint
            switch position {
            case let .rightTop(right, top):
                offset = .easy(12.5 - right, -12.5 + top)
            case let .leftTop(left, top):
                offset = .easy(-12.5 + left, -12.5 + top)
            case let .leftBottom(left, bottom):
                offset = .easy(-12.5 + left, 12.5 - bottom)
            case let .rightBottom(right, bottom):
                offset = .easy(12.5 - right, 12.5 - bottom)
            }
            var frame = tabBar.bounds
            frame.size.height -= UIView.easy.safeArea.bottom
            let badgeView = UIView(frame: frame)
            badgeView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            badgeView.isUserInteractionEnabled = false
            badgeView.backgroundColor = .clear
            self.add(badge: badgeView, tag: index, for: tabBar)
            badgeView.addSubview(badge)
            badge.snp.makeConstraints { (make) in
                make.centerX.equalTo(badgeView).multipliedBy(x).offset(offset.x)
                make.centerY.equalTo(badgeView).multipliedBy(y).offset(offset.y)
            }
        }
    }
    ///设置到指定视图
    public func set(for view: UIView) {
        switch self {
        case .none:
            self.remove(for: view)
        case let .view(badge, position: position):
            self.remove(for: view)
            let multip: CGPoint
            let offset: CGPoint
            switch position {
            case let .rightTop(right, top):
                multip = .easy(2, 0)
                offset = .easy(-right, top)
            case let .leftTop(left, top):
                multip = .easy(0)
                offset = .easy(left, top)
            case let .leftBottom(left, bottom):
                multip = .easy(0, 2)
                offset = .easy(left, -bottom)
            case let .rightBottom(right, bottom):
                multip = .easy(2)
                offset = .easy(-right, -bottom)
            }
            self.add(badge: badge, for: view)
            badge.snp.makeConstraints { (make) in
                if multip.x == 0 {
                    make.centerX.equalTo(offset.x)
                }else{
                    make.centerX.equalTo(view).multipliedBy(multip.x).offset(offset.x)
                }
                if multip.y == 0 {
                    make.centerY.equalTo(offset.y)
                }else{
                    make.centerY.equalTo(view).multipliedBy(multip.y).offset(offset.y)
                }
            }
        }
    }
    ///添加到指定视图
    private func add(badge view:UIView, tag offset: Int = 0, for superView: UIView) {
        view.tag = __ecBadgeTagStartIndex + offset
        superView.addSubview(view)
    }
    ///从指定视图删除
    private func remove(for view: UIView, tag offset: Int = 0) {
        view.viewWithTag(__ecBadgeTagStartIndex + offset)?.removeFromSuperview()
    }
}
extension EasyCoding where Base: UIView {
    ///显示角标
    public func setBadge(_ badge: EasyBadge) {
        badge.set(for: self.base)
    }
}

extension EasyCoding where Base: UITabBar {
    ///显示角标
    public func setBadge(_ badge: EasyBadge, at index: Int) {
        badge.set(for: self.base, at: index)
    }
}
