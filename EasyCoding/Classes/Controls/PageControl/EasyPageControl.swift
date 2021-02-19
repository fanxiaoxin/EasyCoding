//
//  PageControl.swift
//  EasyKit
//
//  Created by Fanxx on 2019/7/25.
//

import UIKit

public class EasyPageControl: UIPageControl {
    //        var image:UIImage?
    //        var currentImage:UIImage?
    public var pointSize: CGSize = CGSize.easy(15, 2.5)
    public var pointCorner: CGFloat = 0
    public var pointSpacing: CGFloat = 10
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.loadView()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadView()
    }
    public func loadView(){
        //            self.image = UIImage(named: "分页")
        //            self.currentImage = UIImage(named: "分页-当前")
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        let width = self.bounds.size.width
        let target = ((pointSize.width + pointSpacing) * CGFloat(self.subviews.count)) - pointSpacing
        let left = (width - target) / 2
        for i in 0..<self.subviews.count {
            let view = self.subviews[i]
            view.frame = CGRect(x: left + CGFloat(i) * (pointSize.width + pointSpacing), y: view.frame.origin.y, width: pointSize.width, height: pointSize.height)
            view.layer.cornerRadius = pointCorner
        }
    }
}

extension EasyBuildable where Self: UIView {
    public static func easyPageControl(_ styles: EasyStyleSetting<EasyPageControl>...) -> EasyPageControl {
        return EasyPageControl().easy(styles: styles)
    }
}

extension EasyStyleSetting where TargetType: EasyPageControl {
    public static func point(size:CGSize) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.pointSize = size
        })
    }
    public static func spacing(_ spacing:CGFloat) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.pointSpacing = spacing
        })
    }
}
