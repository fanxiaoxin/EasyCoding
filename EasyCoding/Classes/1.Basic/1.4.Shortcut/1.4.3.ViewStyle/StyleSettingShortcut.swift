//
//  ViewBuilderShortcut.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/12/20.
//

import UIKit

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
