//
//  UserDefaultProperty.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/4.
//

import Foundation

extension EasyProperty {
    ///提供UserDefaults访问
    @propertyWrapper
    public struct UserDefault<T> {
        ///这里的属性key 和 defaultValue 还有init方法都是实际业务中的业务代码
        ///我们不需要过多关注
        let key: String
        let defaultValue: T

        public init(_ key: String, defaultValue: T) {
            self.key = key
            self.defaultValue = defaultValue
        }
    ///  wrappedValue是@propertyWrapper必须要实现的属性
    /// 当操作我们要包裹的属性时  其具体set get方法实际上走的都是wrappedValue 的set get 方法。
        public var wrappedValue: T {
            get {
                return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
            }
            set {
                UserDefaults.standard.set(newValue, forKey: key)
            }
        }
    }
    ///提供UserDefaults访问
    @propertyWrapper
    public struct UserDefaultNullable<T> {
        let key: String

        public init(_ key: String) {
            self.key = key
        }
    ///  wrappedValue是@propertyWrapper必须要实现的属性
    /// 当操作我们要包裹的属性时  其具体set get方法实际上走的都是wrappedValue 的set get 方法。
        public var wrappedValue: T? {
            get {
                return UserDefaults.standard.object(forKey: key) as? T
            }
            set {
                UserDefaults.standard.set(newValue, forKey: key)
            }
        }
    }
}
