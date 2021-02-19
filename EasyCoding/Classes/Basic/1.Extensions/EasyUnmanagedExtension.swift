//
//  EasyUnmanagedExtension.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/24.
//

import Foundation

extension EasyCoding where Base: AnyObject{
    public func unmanaged() -> Unmanaged<Base> {
        return Unmanaged.passUnretained(self.base)
    }
    ///获取对象内存地址
    public func memoryAddress() -> UnsafeMutableRawPointer {
        return self.unmanaged().toOpaque()
    }
    ///从内存地址获取对象
    public static func memoryAddress(_ value: UnsafeRawPointer) -> Base {
        return Unmanaged<Base>.fromOpaque(value).takeUnretainedValue()
    }
    ///添加引用计数，防止被释放
    @discardableResult
    public func retain() -> Unmanaged<Base>{
        return self.unmanaged().retain()
    }
    ///释放引用，需与retain配对，有多少次retain就要多少次release，否则会造成内存泄漏
    public func release() {
        self.unmanaged().release()
    }
    @discardableResult
    public func autorelease() -> Unmanaged<Base> {
        return self.unmanaged().autorelease()
    }
}
