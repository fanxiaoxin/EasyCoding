//
//  ViewControllerAccessable.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/11/23.
//

import UIKit

public protocol ECViewControllerLoadable {
    ///加载视图的源视图
    var loadSourceViewController: UIViewController { get }
    ///加载目标视图
    @discardableResult
    func load<ControllerType: ECViewControllerType>(_ destination: ControllerType, segue: ECPresentSegue?, otherwise: (()->Void)?) -> ControllerType
}
extension ECViewControllerLoadable {
    ///加载视图的源视图
    public var loadSourceViewController: UIViewController { return UIViewController.easy.current! }
    
    @discardableResult
    public func load<ControllerType: ECViewControllerType>(_ destination: ControllerType, segue: ECPresentSegue? = nil) -> ControllerType {
        return self.load(destination, segue: segue, otherwise: nil)
    }
    @discardableResult
    public func load<ControllerType: ECViewControllerType>(_ destination: ControllerType, otherwise: (()->Void)?) -> ControllerType {
        return self.load(destination, segue: nil, otherwise: otherwise)
    }
}
///实现load方法
extension ECViewControllerLoadable {
    ///不判断前提要求，直接加载
    public func directLoad(_ destination: ECViewControllerType, segue: ECPresentSegue? = nil) {
        self.loadSourceViewController.easy.show(destination, segue: segue ?? destination.segue)
    }
    ///判断权限通过后加载
    @discardableResult
    public func load<ControllerType: ECViewControllerType>(_ destination: ControllerType, segue: ECPresentSegue?, otherwise: (()->Void)?) -> ControllerType {
        let source = self.loadSourceViewController
        if let conditions = destination.preconditions {
            conditions.forEach({ $0.source = source })
            conditions.check(completion: { [weak source] (pass) in
                if pass ?? true {
                    source?.directLoad(destination, segue: segue)
                }else{
                    otherwise?()
                }
            })
        }else{
            source.directLoad(destination, segue: segue)
        }
        return destination
    }
}
///UIViewController使用自身
extension UIViewController: ECViewControllerLoadable {
    ///加载视图的源视图
    public var loadSourceViewController: UIViewController { return self }
}

extension ECViewControllerType {
    ///关闭页面
    public func unload() {
        self.easy.dismiss()
    }
}

extension ECViewControllerCondition: ECViewControllerLoadable {
    public var loadSourceViewController: UIViewController { return self.source ?? UIViewController.easy.current! }
}
