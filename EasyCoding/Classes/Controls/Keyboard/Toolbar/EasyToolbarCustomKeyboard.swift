//
//  EasyToolbarCustomKeyboard.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/8.
//

import UIKit

///自定义的控件
public class EasyToolbarCustomKeyboard<ViewType: UIView, InputType>: EasyToolbarKeyboard<InputType> {
    public let customView: ViewType
    public let valueForView: (ViewType) -> InputType?
    
    public init(customView: ViewType, value: @escaping (ViewType) -> InputType) {
        self.customView = customView
        self.valueForView = value
        super.init(frame: .zero)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    open override func load() {
        super.load()
        
        self.contentView.easy.add(self.customView, layout: .margin)
    }
    open override func currentValue() -> InputType? {
        return self.valueForView(self.customView)
    }
}
