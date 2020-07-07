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

// MARK: 一般命名空间

/// 类型协议
public protocol ECTypeWrapperProtocol {
    associatedtype Base
    var base: Base { get }
    init(value: Base)
}

public struct ECNamespaceWrapper<T>: ECTypeWrapperProtocol {
    public let base: T
    public init(value: T) {
        self.base = value
    }
}
/// 命名空间协议
public protocol ECNamespaceWrappable {
    associatedtype WrapperType
    var easy: WrapperType { get }
    static var easy: WrapperType.Type { get }
}

extension ECNamespaceWrappable {
    public var easy: ECNamespaceWrapper<Self> {
        return ECNamespaceWrapper(value: self)
    }
    public static var easy: ECNamespaceWrapper<Self>.Type {
        return ECNamespaceWrapper.self
    }
}

// MARK: 数组专用

public protocol ECArrayTypeWrapperProtocol: ECTypeWrapperProtocol where Base == [Element] {
    associatedtype Element
}
public struct ECNamespaceArrayWrapper<Element>: ECArrayTypeWrapperProtocol {
    public let base: [Element]
    public init(value: [Element]) {
        self.base = value
    }
}
/// 命名空间协议
public protocol ECNamespaceArrayWrappable: ECNamespaceWrappable {
    associatedtype Element
}
extension ECNamespaceArrayWrappable {
    public var easy: ECNamespaceArrayWrapper<Element> {
        return ECNamespaceArrayWrapper(value: self as! [Element])
    }
    public static var easy: ECNamespaceArrayWrapper<Element>.Type {
        return ECNamespaceArrayWrapper.self
    }
}

// MARK: 字典专用

public protocol ECDictionaryTypeWrapperProtocol: ECTypeWrapperProtocol where Base == [Key: Value] {
    associatedtype Key: Hashable
    associatedtype Value
}
public struct ECNamespaceDictionaryWrapper<Key: Hashable, Value>: ECDictionaryTypeWrapperProtocol {
    public let base: [Key: Value]
    public init(value: [Key: Value]) {
        self.base = value
    }
}
/// 命名空间协议
public protocol ECNamespaceDictionaryWrappable: ECNamespaceWrappable {
    associatedtype Key: Hashable
    associatedtype Value
}
extension ECNamespaceDictionaryWrappable {
    public var easy: ECNamespaceDictionaryWrapper<Key, Value> {
        return ECNamespaceDictionaryWrapper(value: self as! [Key: Value])
    }
    public static var easy: ECNamespaceDictionaryWrapper<Key, Value>.Type {
        return ECNamespaceDictionaryWrapper.self
    }
}

///Easy命令空间
public struct EC {}
extension EC {
    ///一般命名空间扩展定义
    public typealias NamespaceDefine = ECNamespaceWrappable
    ///一般命名空间扩展实现
    public typealias NamespaceImplement = ECTypeWrapperProtocol
    ///数组命名空间扩展定义
    public typealias NamespaceArrayDefine = ECNamespaceArrayWrappable
    ///数组命名空间扩展实现
    public typealias NamespaceArrayImplement = ECArrayTypeWrapperProtocol
    ///字典命名空间扩展定义
    public typealias NamespaceDictionaryDefine = ECNamespaceDictionaryWrappable
    ///字典命名空间扩展实现
    public typealias NamespaceDictionaryImplement = ECDictionaryTypeWrapperProtocol
    ///添加EasyCoding前缀
    internal static func key(_ key: String) -> String {
        return "EasyCoding." + key
    }
}
