//
//  EnvironmentVariableProperty.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/4.
//

import Foundation

extension EasyProperty {
    ///配置环境变量
    @propertyWrapper
    public struct EnvironmentVariable {
        var name: String
        
        public var wrappedValue: String? {
            get {
                guard let pointer = getenv(name) else { return nil }
                return String(cString: pointer)
            }
            set {
                guard let value = newValue else {
                    unsetenv(name)
                    return
                }
                setenv(name, value, 1)
            }
        }
    }
}
