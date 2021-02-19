//
//  CheckBox.swift
//  EasyKit
//
//  Created by Fanxx on 2019/12/18.
//

import UIKit

open class EasyCheckbox: EasyButton {
    ///选中的图片
    open var checkedImage: UIImage? {
        get {
            return self.image(for: .selected)
        }
        set {
            self.setImage(newValue, for: .highlighted)
            self.setImage(newValue, for: .selected)
        }
    }
    ///未选中的图片
    open var uncheckedImage: UIImage? {
        get {
            return self.image(for: .normal)
        }
        set {
            self.setImage(newValue, for: .normal)
        }
    }
    open var isChecked: Bool {
        get {
            return self.isSelected
        }
        set {
            self.isSelected = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.load()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.load()
    }
    override open var canBecomeFirstResponder : Bool {
        return true
    }
    open func load() {
        self.backgroundColor = UIColor.clear
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.titleLabel?.numberOfLines = 0
        self.contentHorizontalAlignment = .left
        self.addTarget(self, action: #selector(self.touchUpInside), for: .touchUpInside)
        ///加载默认样式
        self.easy.loadStaticStyle()
    }
    @objc func touchUpInside(){
        self.isSelected = !self.isSelected
        self.sendActions(for: .valueChanged)
    }
    override open func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        var rect = super.titleRect(forContentRect: contentRect)
        rect.origin.x += 4
        return rect
    }
}

extension EasyBuildable where Self: UIView {
    public static func easyCheckbox(_ styles: EasyStyleSetting<EasyCheckbox>...) -> EasyCheckbox {
        return EasyCheckbox().easy(styles: styles)
    }
}

extension EasyStyleSetting where TargetType: EasyCheckbox {
    public static func check(_ image:UIImage) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.checkedImage = image
        })
    }
    public static func uncheck(_ image:UIImage) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.uncheckedImage = image
        })
    }
    public static func check(_ imageName:String) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.checkedImage = UIImage(named: imageName)
        })
    }
    public static func uncheck(_ imageName:String) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.uncheckedImage = UIImage(named: imageName)
        })
    }
    public static func check(_ value:Bool = true) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.isChecked = value
        })
    }
}
