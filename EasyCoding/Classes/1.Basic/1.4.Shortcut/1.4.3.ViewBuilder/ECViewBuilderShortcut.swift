//
//  ViewBuilderShortcut.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/12/20.
//

import UIKit

public protocol ECBuildable {
}
extension UIView: ECBuildable{}
extension ECBuildable where Self: UIView {
    public static func build(_ builder:(NamespaceWrapper<Self>) -> Void) -> Self {
        let b = Self()
        builder(b.easy)
        return b
    }
    public func build(_ builder:(NamespaceWrapper<Self>) -> Void) -> Self {
        builder(self.easy)
        return self
    }
}

extension Array where Element: UIView {
    ///重复生成类似视图
    public static func `repeat`<ParamsType>(_ parameters: [ParamsType], builder: (NamespaceWrapper<Element>,ParamsType) -> Void) -> [Element] {
        return Element.easy.repeat(parameters, builder: builder)
    }
}

extension ECBuildable where Self: UIView {
    public static func view(_ styles: ECStyleSetting<UIView>...) -> UIView {
        return UIView().easy(styles: styles)
    }
    public static func label(_ styles: ECStyleSetting<UILabel>...) -> UILabel {
        return UILabel().easy(styles: styles)
    }
    public static func button(_ styles: ECStyleSetting<UIButton>...) -> UIButton {
        return UIButton().easy(styles: styles)
    }
    public static func image(_ named: String?, _ styles: ECStyleSetting<UIImageView>...) -> UIImageView {
        let img = UIImageView().easy(styles: styles)
        if let n = named {
            img.image = UIImage(named: n)
        }
        return img
    }
    public static func text(_ styles: ECStyleSetting<UITextField>...) -> UITextField {
        return UITextField().easy(styles: styles)
    }
    public static func textView(_ styles: ECStyleSetting<UITextView>...) -> UITextView {
        return UITextView().easy(styles: styles)
    }
    public static func page(_ styles: ECStyleSetting<UIPageControl>...) -> UIPageControl {
        return UIPageControl().easy(styles: styles)
    }
    public static func slider(_ styles: ECStyleSetting<UISlider>...) -> UISlider {
        return UISlider().easy(styles: styles)
    }
    public static func activityIndicator(_ styles: ECStyleSetting<UIActivityIndicatorView>...) -> UIActivityIndicatorView {
        return UIActivityIndicatorView().easy(styles: styles)
    }
    public static func stack(_ styles: ECStyleSetting<UIStackView>...) -> UIStackView {
        return UIStackView().easy(styles: styles)
    }
}
///更细微的扩展
extension EC.NamespaceImplement where Base: UIView {
    ///添加ScrollView，返回ScrollView的内容页
    @discardableResult
    public func scroll(_ scrollView: UIScrollView? = nil, contentView: UIView? = nil, orientation:ECOrientation = .portrait, layout:[ECViewLayout] = [], style: ECStyleSetting<UIScrollView>...) -> NamespaceWrapper<UIView> {
        let scroll = scrollView ?? UIScrollView()
        style.forEach({$0.action(scroll)})
        let content = contentView ?? UIView()
        let os: ECViewLayout
        switch orientation {
        case .landscape: os = .height
        case .portrait: os = .width
        }
        return self.add(scroll, layout: .margin)
            .add(content, layout: layout, ext: .margin, os)
    }
}
