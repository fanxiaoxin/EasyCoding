//
//  ViewControllerAccessable.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/11/23.
//

import UIKit

public protocol EasyViewControllerLoadable {
    ///加载视图的源视图
    var loadSourceViewController: UIViewController { get }
    ///加载目标视图
    @discardableResult
    func load<ControllerType: EasyViewControllerType>(_ destination: ControllerType, segue: EasyPresentSegue?, otherwise: (()->Void)?) -> ControllerType
}
extension EasyViewControllerLoadable {
    ///加载视图的源视图
    public var loadSourceViewController: UIViewController { return UIViewController.easy.current! }
    
    @discardableResult
    public func load<ControllerType: EasyViewControllerType>(_ destination: ControllerType, segue: EasyPresentSegue? = nil) -> ControllerType {
        return self.load(destination, segue: segue, otherwise: nil)
    }
    @discardableResult
    public func load<ControllerType: EasyViewControllerType>(_ destination: ControllerType, otherwise: (()->Void)?) -> ControllerType {
        return self.load(destination, segue: nil, otherwise: otherwise)
    }
}
///实现load方法
extension EasyViewControllerLoadable {
    ///不判断前提要求，直接加载
    public func directLoad(_ destination: EasyViewControllerType, segue: EasyPresentSegue? = nil) {
        self.loadSourceViewController.easy.show(destination, segue: segue ?? destination.segue)
    }
    ///判断权限通过后加载
    @discardableResult
    public func load<ControllerType: EasyViewControllerType>(_ destination: ControllerType, segue: EasyPresentSegue?, otherwise: (()->Void)?) -> ControllerType {
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
extension UIViewController: EasyViewControllerLoadable {
    ///加载视图的源视图
    public var loadSourceViewController: UIViewController { return self }
}

extension EasyViewControllerType {
    ///关闭页面
    public func unload() {
        self.easy.dismiss()
    }
}

extension EasyViewControllerCondition: EasyViewControllerLoadable {
    public var loadSourceViewController: UIViewController { return self.source ?? UIViewController.easy.current! }
}
