//
//  LoadingView.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/30.
//

import UIKit

///一个简单的加载动画
open class EasyLoadingView: UIView {
    ///转一圈所需的时间
    open var duration: TimeInterval = 1.5 { didSet { self.needRedraw = true } }
    ///小球个数
    open var circleCount: Int = 10 { didSet { self.needRedraw = true } }
    ///每个小球的大小
    open var circleSize: CGFloat = 6 { didSet { self.needRedraw = true } }
    ///整个Loading的大小
    open var defaultSize: CGSize = CGSize(width: 50, height: 50) { didSet { self.needRedraw = true } }
    ///颜色
    open var color: UIColor = EasyControlSetting.Color.main { didSet { self.needRedraw = true } }
    ///用于设置及判断是否需要重新创建动画
    var needRedraw = true
    ///缓存的动画层
    var animationLayer: CALayer?
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        if self.needRedraw {
            self.animationLayer?.removeFromSuperlayer()
            let layer = self.creatAnimationLayout()
            self.layer.addSublayer(layer)
            self.animationLayer = layer
        }
    }
    open override var intrinsicContentSize: CGSize {
        return self.defaultSize
    }
    ///根据参数创建动画层
    open func creatAnimationLayout() -> CALayer {
        // 大小变化
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        
        scaleAnimation.keyTimes = [0, 0.5, 1]
        scaleAnimation.values = [1, 0.4, 1]
        scaleAnimation.duration = duration
        
        // 透明度变化
        let opacityAnimaton = CAKeyframeAnimation(keyPath: "opacity")
        //该属性是一个数组，用以指定每个子路径的时间。
        opacityAnimaton.keyTimes = [0, 0.5, 1]
        //values属性指明整个动画过程中的关键帧点，需要注意的是，起点必须作为values的第一个值。
        opacityAnimaton.values = [1, 0.3, 1]
        opacityAnimaton.duration = duration
        
        // 组动画
        let animation = CAAnimationGroup()
        //将大小变化和透明度变化的动画加入到组动画
        animation.animations = [scaleAnimation, opacityAnimaton]
        //动画的过渡效果
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        //动画的持续时间
        animation.duration = duration
        //设置重复次数,HUGE可看做无穷大，起到循环动画的效果
        animation.repeatCount = HUGE
        //运行一次是否移除动画
        animation.isRemovedOnCompletion = false
        
        let size = self.bounds.size
        
        let beginTime: CFTimeInterval = 0
        let beginTimes: [CFTimeInterval] = .init(unsafeUninitializedCapacity: self.circleCount) { (buffer, count) in
            let step = CFTimeInterval(self.duration) / CFTimeInterval(self.circleCount)
            for i in 0..<self.circleCount {
                buffer[i] = step * CFTimeInterval(i + 1)
            }
            count = self.circleCount
        }
        let layer = CALayer()
        // Draw circles
        for i in 0..<self.circleCount {
            let angle = CGFloat.pi / CGFloat(self.circleCount) * 2 * CGFloat(i)
            let circle = creatCircle(angle: angle,
                                     size: circleSize,
                                     origin: .zero,
                                     containerSize: size,
                                     color: color)
            animation.beginTime = beginTime + beginTimes[i]
            circle.add(animation, forKey: "animation")
            layer.addSublayer(circle)
        }
        self.needRedraw = false
        return layer
    }
    func creatCircle(angle: CGFloat, size: CGFloat, origin: CGPoint, containerSize: CGSize, color: UIColor) -> CALayer {
        let radius = containerSize.width/2
        let circle = createLayerWith(size: CGSize(width: size, height: size), color: color)
        let frame = CGRect(
            x: origin.x + radius * (cos(angle) + 1) - size / 2,
            y: origin.y + radius * (sin(angle) + 1) - size / 2,
            width: size,
            height: size)
        circle.frame = frame
        
        return circle
        
    }
    func createLayerWith(size: CGSize, color: UIColor) -> CALayer {
        let layer: CAShapeLayer = CAShapeLayer()
        let path: UIBezierPath = UIBezierPath()
        /**
         center: CGPoint 中心点
         radius: CGFloat 半径
         startAngle: CGFloat 起始的弧度
         endAngle: CGFloat 结束的弧度
         clockwise: Bool 绘画方向 true：顺时针 false：逆时针
         */
        path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                    radius: size.width / 2,
                    startAngle: 0,
                    endAngle: 2 * CGFloat.pi,
                    clockwise: false);
        //线宽，如果画圆填充的话也可以不设置
        layer.lineWidth = 2
        //填充颜色，这里也就是圆的颜色
        layer.fillColor = color.cgColor
        //图层背景色
        layer.backgroundColor = nil
        //把贝塞尔曲线路径设为layer的渲染路径
        layer.path = path.cgPath
        
        return layer;
    }
}

extension EasyStyleSetting where TargetType: EasyLoadingView {
    ///转一圈所需的时间
    public static func duration(_ duration: TimeInterval) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.duration =  duration
        })
    }
    ///小球个数
    public static func circle(count: Int) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.circleCount = count
        })
    }
    ///每个小球的大小
    public static func circle(size: CGFloat) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.circleSize =  size
        })
    }
    ///颜色
    public static func color(_ color: UIColor) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.color =  color
        })
    }
    ///颜色
    public static func color(rgb color: UInt32) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.color = .easy(color)
        })
    }
}
