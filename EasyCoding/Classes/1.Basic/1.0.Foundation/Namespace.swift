//
//  EasyNamespace.swift
//  EasyKit
//
//  Created by Fanxx on 2019/4/3.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import UIKit
/**************
 规则说明（以Cls举例代表具体类名）：
 
 类名统一为：ECCls
 即：
 class ECCls {}
 
 系统或外部类扩展统一为：Cls.easy.***
 即：
 extension Cls: EC.NamespaceDefine {}
 extension EC.NamespaceImplement where Base == Cls {
     ***
 }
**************/

/// 类型协议
public protocol TypeWrapperProtocol {
    associatedtype Base
    var base: Base { get }
    init(value: Base)
}

public struct NamespaceWrapper<T>: TypeWrapperProtocol {
    public let base: T
    public init(value: T) {
        self.base = value
    }
}
/// 命名空间协议
public protocol NamespaceWrappable {
    associatedtype WrapperType
    var easy: WrapperType { get }
    static var easy: WrapperType.Type { get }
}

extension NamespaceWrappable {
    public var easy: NamespaceWrapper<Self> {
        return NamespaceWrapper(value: self)
    }
    public static var easy: NamespaceWrapper<Self>.Type {
        return NamespaceWrapper.self
    }
}

/* 示例
 extension UIColor: NamespaceWrappable {}
 extension TypeWrapperProtocol where Base == UIColor {
 /// 用自身颜色生成UIImage
 var image: UIImage? {
 let rEasyt = CGREasyt(x: 0, y: 0, width: 1, height: 1)
 UIGraphicsBeginImagEasyontext(rEasyt.size)
 let context = UIGraphicsGetCurrentContext()
 context?.setFillColor(wrappedValue.cgColor)
 context?.fill(rEasyt)
 let image = UIGraphicsGetImageFromCurrentImagEasyontext()
 return image
 }
 }
 func test() {
 UIColor().Easy.image
 }
 */

///Easy命令空间
public struct EC {}
extension EC {
    public typealias NamespaceDefine = NamespaceWrappable
    public typealias NamespaceImplement = TypeWrapperProtocol
}
/* 示例
 extension UIColor: Easy.NamespaceDefine {}
 extension Easy.NamespaceImplement where Base == UIColor {
 var test:UIImage? {
 return nil
 }
 }
*/
