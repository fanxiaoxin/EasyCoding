//
//  StackViewStyle.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/17.
//

import UIKit

extension ECStyleSetting where TargetType: UIStackView {
    ///方向
    public static func axis(_ axis:NSLayoutConstraint.Axis) -> ECStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.axis = axis
        })
    }
    ///子视图的分布比例
    public static func distribution(_ distribution:UIStackView.Distribution) -> ECStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.distribution = distribution
        })
    }
    ///子视图的对其方式（
    public static func alignment(_ alignment:UIStackView.Alignment) -> ECStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.alignment = alignment
        })
    }
    ///子视图之间的间距
    public static func spacing(_ spacing:CGFloat) -> ECStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.spacing = spacing
        })
    }
    ///子视图之间的间距
    @available(iOS 11.0, *)
    public static func sustomSpacing(_ spacing:CGFloat, after arrangedSubview: UIView) -> ECStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.setCustomSpacing(spacing, after: arrangedSubview)
        })
    }
    public static func baselineRelativeArrangement(_ isBaselineRelativeArrangement:Bool) -> ECStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.isBaselineRelativeArrangement = isBaselineRelativeArrangement
        })
    }
    public static func layoutMarginsRelativeArrangement(_ isLayoutMarginsRelativeArrangement:Bool) -> ECStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.isLayoutMarginsRelativeArrangement = isLayoutMarginsRelativeArrangement
        })
    }
}
