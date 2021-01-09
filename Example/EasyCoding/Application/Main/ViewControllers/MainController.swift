//
//  MainController.swift
//  Mdb-India
//
//  Created by Fanxx on 2019/11/15.
//  Copyright © 2019 TianYin. All rights reserved.
//

import UIKit
import EasyCoding
import Moya
import Result

///主视图
class MainController: UITabBarController, UITabBarControllerDelegate, ECViewControllerType {
    var segue: ECPresentSegue { return ECPresentSegue.popup }
    
    var preconditions: [ECViewControllerCondition]? { return nil}
    
    let whenStartupCompleted = ECOnceEvent()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let c1 = ExampleController()
        let c2 = ViewController<UIView>()
        let c3 = ViewController<UIView>()
        
        c2.view.easy(.bg(.systemGreen))
        c3.view.easy(.bg(.systemYellow))
        
        let n1 = NavigationController(rootViewController: c1)
        let n2 = NavigationController(rootViewController: c2)
        let n3 = NavigationController(rootViewController: c3)
        
        self.load(n1, segue: ECPresentSegue.TabBar(title:"One", iconNamed: "未选图片", selectedNamed: "选中图片"))
        self.load(n2, segue: ECPresentSegue.TabBar(title:"Two", iconNamed: "未选图片", selectedNamed: "选中图片"))
        self.load(n3, segue: ECPresentSegue.TabBar(title:"Three", iconNamed: "未选图片", selectedNamed: "选中图片"))
        
        for item in self.tabBar.items! {
            item.imageInsets = .init(top: -2, left: 0, bottom: 2, right: 0)
            item.titlePositionAdjustment = .init(horizontal: 0, vertical: -5)
            item.setTitleTextAttributes(.easy(.color(Style.Color.main)), for: .selected)
            item.setTitleTextAttributes(.easy(.color(Style.Color.Font.light)), for: .normal)
        }
        
        self.tabBar.easy.setBadge(.point(), at: 0)
        self.tabBar.easy.setBadge(.value(20), at: 2)
        self.tabBar.items?[1].badgeValue = "20"
        //启动流程
        //        self.start(.startup{
        //            self.isStartupCompleted = true
        //            })
        
        self.delegate = self
        
        //页面加载完成
        self.whenStartupCompleted()
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController == self.viewControllers?[2] {
            self.tabBar.easy.setBadge(.none, at: 2)
        } else if viewController == self.viewControllers?[1] {
            self.tabBar.easy.setBadge(.value(15), at: 2)
        }
    }
}

enum MainTabIndex: Int {
    case one = 0
    case two = 1
    case three = 2
}

extension MainController {
    ///去到指定页面
    func to(index:MainTabIndex){
        self.directTo(index: index)
    }
    private func directTo(index:MainTabIndex){
        let idx = index.rawValue
        let orgIndex = self.selectedIndex
        let animated = orgIndex == idx
        self.selectedIndex = idx
        if let nav = self.viewControllers?[idx] as? UINavigationController {
            _ = nav.popToRootViewController(animated: animated)
        }
        if !animated {
            if let nav = self.viewControllers?[orgIndex] as? UINavigationController {
                _ = nav.popToRootViewController(animated: false)
            }
        }
    }
}
extension ViewController {
    ///去到指定页面
    func to(tab:MainTabIndex){
        var controller: UIViewController? = self
        if let segue = self.easy.currentSegue {
            if segue is ECPresentSegue.Popup || segue is ECPresentSegue.PopupReplace {
                controller = segue.source
                self.onClose()
            }
        }
        if let main = controller?.tabBarController as? MainController {
            main.to(index: tab)
        }else{
            (UIApplication.shared.delegate?.window??.rootViewController as? MainController)?.to(index: tab)
        }
    }
}




/*
 ///动态设置提供器类型
 public protocol ECDynamicPropertyProviderType {
 ///根据指定参数返回对应的值
 func value<ValueType, Value>(for key: DynamicValueProviderType) -> Value
 }
 ///可动态设置属性
 public protocol ECPropertyDynamically {
 ///动态设置提供器类型
 associatedtype DynamicProviderType: ECDynamicPropertyProviderType
 }
 extension ECPropertyDynamically {
 ///动态属性，可在运行时动态改变值
 public func dynamic<PropertyType>(_ keyPath: WritableKeyPath<UIView, PropertyType?>, value: PropertyType) {
 self.base[keyPath: keyPath] = value
 }
 }
 
 ///动态属性，可在运行时动态改变值
 class DynamicProperty<ClassType> {
 
 }
 
 enum ColorIndex {
 case main
 case sub
 case button
 case title
 }
 struct DynamicTarget {
 weak var object: UIView?
 let keyPath: WritableKeyPath<UIView, UIColor?>
 let index: ColorIndex
 }
 class DynamicObjects {
 static let shared = DynamicObjects()
 var targets:[DynamicTarget] = []
 
 func color(for index: ColorIndex) -> UIColor {
 return .blue
 }
 func set(keyPath: WritableKeyPath<UIView, UIColor?>, value: ColorIndex, for object: UIView) {
 var o = object
 o[keyPath: keyPath] = self.color(for: value)
 }
 func update() {
 for target in self.targets {
 target.object?[keyPath: target.keyPath] = self.color(for: target.index)
 }
 }
 }
 extension UIView {
 func dynamic(_ keyPath: WritableKeyPath<UIView, UIColor?>, value: ColorIndex) {
 DynamicObjects.shared.objects.append(self)
 DynamicObjects.shared.color(for: value)
 }
 }
 func test2() {
 let view = UIView()
 view.dynamic(\.backgroundColor, value: .main)
 }
 
 */

///动态属性的值
public protocol DynamicPropertyValueType {
    associatedtype RawValue
    var rawValue: RawValue { get }
    init?(rawValue: RawValue)
}
///动态属性对象包装
@dynamicMemberLookup
struct DynamicPropertyObject<T> {
    private var _get: () -> T
    private var _set: (T) -> ()
    
    var object: T {
        get { return _get()  }
        nonmutating set { _set(newValue) }
    }
    
    init(_ object: T) {
        var x = object
        _get = { x }
        _set = { x = $0 }
    }
    subscript<ValueType: DynamicPropertyValueType>(dynamicMember kp: WritableKeyPath<T, ValueType.RawValue?>) -> ValueType? {
        get {
            if let value = self.object[keyPath: kp] {
                return ValueType(rawValue: value)
            }
            return nil
        }
        nonmutating set {
            self.object[keyPath: kp] = newValue?.rawValue
        }
    }
    subscript<ValueType: DynamicPropertyValueType>(dynamicMember kp: WritableKeyPath<T, ValueType.RawValue>) -> ValueType? {
        get {
            return ValueType(rawValue: self.object[keyPath: kp])
        }
        nonmutating set {
            if let value = newValue?.rawValue {
                self.object[keyPath: kp] = value
            }
        }
    }
}
