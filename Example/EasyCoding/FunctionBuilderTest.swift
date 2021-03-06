//
//  FunctionBuilderTest.swift
//  EasyCoding_Example
//
//  Created by JY_NEW on 2020/6/3.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import EasyCoding

public struct EasyTypeWarpper<T>: EasyTypeWrapperProtocol {
    public let base: T
    public init(value: T) {
        self.base = value
    }
}

///泛型抽象类
public protocol EasyGenericType {
    var types: [Any.Type] { get }
}
public extension EasyGenericType {
    func type<T>(for index: Int) -> T.Type {
        return self.types[index] as! T.Type
    }
}
public protocol MyTypeBase: EasyGenericType {
    
}
public protocol MyType: MyTypeBase {
    associatedtype Element
    func fuck(for element: Element)
}
extension MyType {
    public var types: [Any.Type] {
        return [Element.self]
    }
}
public class my<Element>: MyType {
    var other: EasyTypeWarpper<EasyGenericType>?
    public func fuck(for element: Element) {
        
    }
}
///代表一个组件，大到一个系统，模块，小到一个Controller或者更小
protocol EasyComponentType { }
///需要显示UI的组件
protocol EasyUIComponentType: EasyComponentType { }
///可加载组件
protocol EasyComponentLoadable { }
///组件加载场景
protocol EasyComponentLoadingSegueType: EasyEmptyInstantiable {
    associatedtype LoaderType
    associatedtype ComponentType
    ///加载
    func load(for loader: LoaderType, component: ComponentType)
    ///卸载
    func unload(for component: ComponentType)
}
/*
//1. ViewControler + ViewController
//2. Business + ViewController
//3. ViewController + Business
//4. Business + Business
extension EasyComponentLoadable {
    ///加载另一个组件
    func load<SegueType: EasyComponentLoadingSegueType>(_ component: SegueType.ComponentType, segue: SegueType) where  Self: SegueType.LoaderType {
        segue.load(for: self, component: component)
    }
}
class A1: EasyComponentType {
    
}
class AS: EasyComponentLoadingSegueType {
    var source: EasyComponentLoadable
    
    var destination: EasyComponentType
    
    func load() {
        
    }
    
    func unload() {
        
    }
}
class A: EasyComponentLoadable {
    
}
class AB: A {
    
}
class AT {
    func FF()  {
        AB().load(A1(), segue: AS())
    }
}
*/
///组件化模块
protocol EasyModuleType {
    ///模块需求，每个模块自定义自己的协议，这样设置的时候有遗漏编译器会警告
    associatedtype RequirementProtocol
    ///模块产出
    associatedtype ExportProtocol
    ///放置当前模块正常运转所需要的操作
    var requirement: RequirementProtocol { get set }
    ///放置当前模块可提供给其他模块的操作
    var export: ExportProtocol { get set }
    static var shared: Self { get }
}
///主模块，负责调配组装所有模块，装配每个模块的config, requirement和exprot属性
protocol EasyMainModuleType: EasyModuleType {
    ///在该方法装配所有模块
    func assembly()
}
///基础模块，负责整个框架的基础设施
protocol EasyBasicModuleType: EasyModuleType {
    
}
///上下文模块，负责维护整个项目使用到的上下文信息，如登录信息，注意仅维护全局的，各模块的上下文信息由自身去维护
protocol EasyContextModuleType: EasyModuleType {
    
}
///具体的业务模块
protocol EasyBusinessModuleType: EasyModuleType {
    
}
///第三方业务模块，由主模块去配置
protocol EasyThreePartyModuleType: EasyModuleType {
    
}

///模块产出
 protocol TestModuleRequirementType{
    func isLogined() -> Bool
    func login(_ user:String, completion: () -> Void)
}
 struct TestModuleRequirement: TestModuleRequirementType {
    public func isLogined() -> Bool {
        return true
    }
    public func login(_ user:String, completion: () -> Void) -> Void {
        
    }
}
 protocol TestModuleExportType {
    func testMe()
}
class TestModuleExport: TestModuleExportType {
    func testMe() {
        
    }
}
final class TestModule: EasyBusinessModuleType {
    static let shared = TestModule()
    
    typealias RequirementProtocol = TestModuleRequirementType
    typealias ExportProtocol = TestModuleExportType
    var requirement: RequirementProtocol = TestModuleRequirement()
    var export: ExportProtocol = TestModuleExport()
    var config: EasyNull = easyNull
}
func xxx() {
    if TestModule().requirement.isLogined() {
        
    }
}

//1. 加载ViewController
//2. 调用方法
//2.1 有返回值
//2.1.1 同步
//2.1.2 异步
//2.2 无返回值
    
///命令模式
protocol EasyCommandType {
    associatedtype InputType
    associatedtype OutputType
    var input: InputType { get set }
    var conditions: [Any] { get set }
    var method: Any { get set }
    ///命令接收者
    var receiver: EasyCommandReceiverType { get set }
    ///执行命令
    func execute(completion: (OutputType)->Void)
}
///接收命令的目标
protocol EasyCommandReceiverType {
    
}
///执行命令的对象
protocol EasyCommandInvokerType {
    associatedtype CommandType: EasyCommandType
    var command: CommandType { get set }
    ///执行命令
    func call()
}

@_functionBuilder
struct AttributedStringBuilder {
    static func buildBlock() -> NSAttributedString {
        return NSAttributedString(string: "I'm Default")
    }
  static func buildBlock(_ segments: NSAttributedString...) -> NSAttributedString {
    let string = NSMutableAttributedString()
    segments.forEach { string.append($0) }
    return string
  }
    static func buildBlock(_ string: String,_ color: UIColor) -> NSAttributedString {
    return NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor : color])
  }
    static func buildIf(_ string: NSAttributedString?) -> NSAttributedString  {
        return string ?? NSAttributedString(string: " Nothing")
    }
    static func buildEither(first: NSAttributedString) -> NSAttributedString {
        return first
    }
    static func buildEither(second: NSAttributedString) -> NSAttributedString {
        return second
    }
}
extension NSAttributedString {
  convenience init(@AttributedStringBuilder _ content: (Int) -> NSAttributedString) {
    self.init(attributedString: content(3))
  }
}

class TEST {
    func haha() {
        let hello = NSAttributedString(string: "Hello")
        let world = NSAttributedString(string: "World")
        let test1 = false
        let test2 = true
       let str =
        NSAttributedString {i in
            hello
            world
            if test1 {
                world
            }
            if test2 {
                hello
            }else{
                world
            }
        }
        print(str)
        let str2 = NSAttributedString{i in
            "fuck you\(i)"
            UIColor.red
        }
        print(str2)
        let str3 = NSAttributedString { (_) -> NSAttributedString in
            "SHit"
            UIColor.blue
        }
        print(str3)
//        
//        firstly {
//            URLSession.shared.dataTask(.promise, with: URLRequest.init(stringLiteral: "https://www.baidu.com"))
//        }.done { obj in
//            
//        }
    }
}
