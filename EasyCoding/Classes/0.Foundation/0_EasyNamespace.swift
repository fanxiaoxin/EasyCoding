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
 
 类名统一为：EasyCls
 即：
 class EasyCls {}
 
 系统或外部类扩展统一为：Cls.easy.***
 即：
 extension Cls: Easy.NamespaceDefine {}
 extension Easy.NamespaceImplement where Base == Cls {
     ***
 }
**************/

// MARK: 一般命名空间

/// 类型协议
public protocol EasyTypeWrapperProtocol {
    associatedtype Base
    var base: Base { get }
    init(value: Base)
}

public struct EasyNamespaceWrapper<T>: EasyTypeWrapperProtocol {
    public let base: T
    public init(value: T) {
        self.base = value
    }
}
/// 命名空间协议
public protocol EasyNamespaceWrappable {
    associatedtype WrapperType
    var easy: WrapperType { get }
    static var easy: WrapperType.Type { get }
}

extension EasyNamespaceWrappable {
    public var easy: EasyNamespaceWrapper<Self> {
        return EasyNamespaceWrapper(value: self)
    }
    public static var easy: EasyNamespaceWrapper<Self>.Type {
        return EasyNamespaceWrapper.self
    }
}

// MARK: 数组专用

public protocol EasyArrayTypeWrapperProtocol: EasyTypeWrapperProtocol where Base == [Element] {
    associatedtype Element
}
public struct EasyNamespaceArrayWrapper<Element>: EasyArrayTypeWrapperProtocol {
    public let base: [Element]
    public init(value: [Element]) {
        self.base = value
    }
}
/// 命名空间协议
public protocol EasyNamespaceArrayWrappable: EasyNamespaceWrappable {
    associatedtype Element
}
extension EasyNamespaceArrayWrappable {
    public var easy: EasyNamespaceArrayWrapper<Element> {
        return EasyNamespaceArrayWrapper(value: self as! [Element])
    }
    public static var easy: EasyNamespaceArrayWrapper<Element>.Type {
        return EasyNamespaceArrayWrapper.self
    }
}

// MARK: 字典专用

public protocol EasyDictionaryTypeWrapperProtocol: EasyTypeWrapperProtocol where Base == [Key: Value] {
    associatedtype Key: Hashable
    associatedtype Value
}
public struct EasyNamespaceDictionaryWrapper<Key: Hashable, Value>: EasyDictionaryTypeWrapperProtocol {
    public let base: [Key: Value]
    public init(value: [Key: Value]) {
        self.base = value
    }
}
/// 命名空间协议
public protocol EasyNamespaceDictionaryWrappable: EasyNamespaceWrappable {
    associatedtype Key: Hashable
    associatedtype Value
}
extension EasyNamespaceDictionaryWrappable {
    public var easy: EasyNamespaceDictionaryWrapper<Key, Value> {
        return EasyNamespaceDictionaryWrapper(value: self as! [Key: Value])
    }
    public static var easy: EasyNamespaceDictionaryWrapper<Key, Value>.Type {
        return EasyNamespaceDictionaryWrapper.self
    }
}

///Easy命令空间
public struct Easy {}
extension Easy {
    ///一般命名空间扩展定义
    public typealias NamespaceDefine = EasyNamespaceWrappable
    ///一般命名空间扩展实现
    public typealias NamespaceImplement = EasyTypeWrapperProtocol
    ///数组命名空间扩展定义
    public typealias NamespaceArrayDefine = EasyNamespaceArrayWrappable
    ///数组命名空间扩展实现
    public typealias NamespaceArrayImplement = EasyArrayTypeWrapperProtocol
    ///字典命名空间扩展定义
    public typealias NamespaceDictionaryDefine = EasyNamespaceDictionaryWrappable
    ///字典命名空间扩展实现
    public typealias NamespaceDictionaryImplement = EasyDictionaryTypeWrapperProtocol
    ///添加EasyCoding前缀
    internal static func key(_ key: String) -> String {
        return "EasyCoding." + key
    }
}
///需要使用.easy扩展的可继承自该类型
public typealias EasyExtension = Easy.NamespaceDefine
public typealias EasyArrayExtension = Easy.NamespaceArrayDefine
public typealias EasyDictionaryExtension = Easy.NamespaceDictionaryDefine
///扩展EasyCoding的属性和方法
public typealias EasyCoding = Easy.NamespaceImplement
///扩展数组的EasyCoding扩展
public typealias EasyArray = Easy.NamespaceArrayImplement
///扩展字典的EasyCoding扩展
public typealias EasyDictionary = Easy.NamespaceDictionaryImplement
