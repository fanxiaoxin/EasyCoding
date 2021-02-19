//
//  ViewBuilderShortcut.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/12/20.
//

import UIKit

public protocol EasyBuildable {
}
extension UIView: EasyBuildable{}
extension EasyBuildable where Self: UIView {
    public static func easy(_ builder:(EasyNamespaceWrapper<Self>) -> Void) -> Self {
        let b = Self()
        builder(b.easy)
        return b
    }
    public func easy(_ builder:(EasyNamespaceWrapper<Self>) -> Void) -> Self {
        builder(self.easy)
        return self
    }
}

extension Array where Element: UIView {
    ///重复生成类似视图
    public static func easy<ParamsType>(repeat parameters: [ParamsType], builder: (EasyNamespaceWrapper<Element>,ParamsType) -> Void) -> [Element] {
        return Element.easy.repeat(parameters, builder: builder)
    }
}

extension EasyBuildable where Self: UIView {
    public static func view(_ styles: EasyStyleSetting<UIView>...) -> UIView {
        return UIView().easy(styles: styles)
    }
    public static func label(_ styles: EasyStyleSetting<UILabel>...) -> UILabel {
        return UILabel().easy(styles: styles)
    }
    public static func button(_ styles: EasyStyleSetting<UIButton>...) -> UIButton {
        return UIButton().easy(styles: styles)
    }
    public static func image(_ named: String?, _ styles: EasyStyleSetting<UIImageView>...) -> UIImageView {
        let img = UIImageView().easy(styles: styles)
        if let n = named {
            img.image = UIImage(named: n)
        }
        return img
    }
    public static func text(_ styles: EasyStyleSetting<UITextField>...) -> UITextField {
        return UITextField().easy(styles: styles)
    }
    public static func textView(_ styles: EasyStyleSetting<UITextView>...) -> UITextView {
        return UITextView().easy(styles: styles)
    }
    public static func page(_ styles: EasyStyleSetting<UIPageControl>...) -> UIPageControl {
        return UIPageControl().easy(styles: styles)
    }
    public static func slider(_ styles: EasyStyleSetting<UISlider>...) -> UISlider {
        return UISlider().easy(styles: styles)
    }
    public static func activityIndicator(_ styles: EasyStyleSetting<UIActivityIndicatorView>...) -> UIActivityIndicatorView {
        return UIActivityIndicatorView().easy(styles: styles)
    }
    public static func stack(_ styles: EasyStyleSetting<UIStackView>...) -> UIStackView {
        return UIStackView().easy(styles: styles)
    }
}
///更细微的扩展
extension EasyCoding where Base: UIView {
    ///添加ScrollView，返回ScrollView的内容页
    @discardableResult
    public func scroll(_ scrollView: UIScrollView? = nil, contentView: UIView? = nil, orientation:EasyOrientation = .portrait, layout:[EasyViewLayout] = [], style: EasyStyleSetting<UIScrollView>...) -> EasyNamespaceWrapper<UIView> {
        let scroll = scrollView ?? UIScrollView()
        style.forEach({$0.action(scroll)})
        let content = contentView ?? UIView()
        let os: EasyViewLayout
        switch orientation {
        case .landscape: os = .height
        case .portrait: os = .width
        }
        return self.add(scroll, layout: .margin)
            .add(content, layout: layout, ext: .margin, os)
    }
}
