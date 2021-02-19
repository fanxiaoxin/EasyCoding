//
//  StackViewStyle.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/17.
//

import UIKit

extension EasyStyleSetting where TargetType: UIStackView {
    ///添加子视图
    public static func views(_ views:[UIView]) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            for view in views {
                target.addArrangedSubview(view)
            }
        })
    }
    ///插入子视图
    public static func insert(view:UIView, at index: Int) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.insertArrangedSubview(view, at: index)
        })
    }
    ///插入子视图
    public static func insert(views:[UIView], at index: Int) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            for view in views.reversed() {
                target.insertArrangedSubview(view, at: index)
            }
        })
    }
    ///方向
    public static func axis(_ axis:NSLayoutConstraint.Axis) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.axis = axis
        })
    }
    ///子视图的分布比例
    public static func distribution(_ distribution:UIStackView.Distribution) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.distribution = distribution
        })
    }
    ///子视图的对其方式（
    public static func alignment(_ alignment:UIStackView.Alignment) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.alignment = alignment
        })
    }
    ///子视图之间的间距
    public static func spacing(_ spacing:CGFloat) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.spacing = spacing
        })
    }
    ///子视图之间的间距
    @available(iOS 11.0, *)
    public static func sustomSpacing(_ spacing:CGFloat, after arrangedSubview: UIView) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.setCustomSpacing(spacing, after: arrangedSubview)
        })
    }
    public static func baselineRelativeArrangement(_ isBaselineRelativeArrangement:Bool) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.isBaselineRelativeArrangement = isBaselineRelativeArrangement
        })
    }
    public static func layoutMarginsRelativeArrangement(_ isLayoutMarginsRelativeArrangement:Bool) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.isLayoutMarginsRelativeArrangement = isLayoutMarginsRelativeArrangement
        })
    }
}
