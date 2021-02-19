//
//  PresentSegue.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/6/4.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import UIKit

public protocol EasyPresentSegueType {
    ///当前Controller，必须为weak
    var source: UIViewController? { get set }
    ///目标Controller，必须为weak
    var destination: UIViewController? { get set }
    
    ///继承的类使用该方法实现操作
    func performAction(completion:(()->Void)?)
    ///继承的类使用该方法实现操作
    func unwindAction()
    
    ///在当前场景后加载新的场景时会使用该方法，默认直接调用新场景的directPerform
    func performNext(segue: EasyPresentSegueType, completion:(()->Void)?)
}
///自定义加载，放在destination上，source并不会调用
public protocol EasyPresentSegueCustomizable: UIViewController {
    ///返回true可自定义自身加载过程
    func custom(perform segue: EasyPresentSegueType, completion:(()->Void)?) -> Bool
    ///返回true可自定义自身卸载过程
    func custom(unwind segue: EasyPresentSegueType) -> Bool
}
extension EasyPresentSegueCustomizable {
    ///返回true可自定义自身加载过程
    public func custom(perform segue: EasyPresentSegueType, completion:(()->Void)?) -> Bool {
        return false
    }
    ///返回true可自定义自身卸载过程
    public func custom(unwind segue: EasyPresentSegueType) -> Bool {
        return false
    }
}
extension EasyPresentSegueType {
    ///执行
    public func perform(completion:(()->Void)? = nil) {
        if let custom = self.destination as? EasyPresentSegueCustomizable {
            if !custom.custom(perform: self, completion: completion) {
                self.directPerform(completion: completion)
            }
        }else{
            self.directPerform(completion: completion)
        }
    }
    ///释放
    public func unwind() {
        if let custom = self.destination as? EasyPresentSegueCustomizable {
            if !custom.custom(unwind: self) {
                self.directUnwind()
            }
        }else{
            self.directUnwind()
        }
    }
    ///直接执行，外部调用请用perform()
    public func directPerform(completion:(()->Void)?) {
        if let preSegue = self.source?.easy.currentSegue {
            preSegue.performNext(segue: self, completion: completion)
        }else{
            self.performAction(completion: completion)
        }
    }
    ///直接释放，外部调用请用unwind()
    public func directUnwind() {
        self.unwindAction()
    }
    ///在当前场景后加载新的场景时会使用该方法，默认直接调用新场景的directPerform
    public func performNext(segue: EasyPresentSegueType, completion:(()->Void)?) {
        segue.performAction(completion: completion)
    }
}

fileprivate let __easyPresentSegueTypeKey = "EasyComponents.PresentSegueType"
extension EasyCoding where Base: UIViewController {
    public var currentSegue: EasyPresentSegueType? {
        return self.getAssociated(object: __easyPresentSegueTypeKey)
    }
    internal func currentSegue(_ segue: EasyPresentSegueType?) {
        self.setAssociated(object: segue, key: __easyPresentSegueTypeKey)
    }
    public func show(_ viewController: UIViewController ,segue: EasyPresentSegueType){
        weak var source = self.base
        weak var destination = viewController
        var s = segue
        s.source = source
        s.destination = destination
        viewController.easy.currentSegue(s)
        s.perform()
    }
    public func dismiss() {
        if let segue = self.currentSegue  {
            segue.unwind()
            self.currentSegue(nil)
        }
    }
}
