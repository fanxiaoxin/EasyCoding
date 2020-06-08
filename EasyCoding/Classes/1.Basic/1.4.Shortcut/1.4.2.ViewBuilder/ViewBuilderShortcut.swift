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
