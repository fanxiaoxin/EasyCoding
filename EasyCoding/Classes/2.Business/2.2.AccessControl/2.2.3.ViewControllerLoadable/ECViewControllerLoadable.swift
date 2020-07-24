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
    func load(_ destination: ECViewControllerType, segue: ECPresentSegue?, otherwise: (()->Void)?)
}
extension ECViewControllerLoadable {
    ///加载视图的源视图
    public var loadSourceViewController: UIViewController { return UIViewController.easy.current! }

    public func load(_ destination: ECViewControllerType, segue: ECPresentSegue? = nil) {
        self.load(destination, segue: segue, otherwise: nil)
    }
    public func load(_ destination: ECViewControllerType, otherwise: (()->Void)?) {
        self.load(destination, segue: nil, otherwise: otherwise)
    }
}
///实现load方法
extension ECViewControllerLoadable {
    ///不判断前提要求，直接加载
    public func directLoad(_ destination: ECViewControllerType, segue: ECPresentSegue? = nil) {
        self.loadSourceViewController.easy.show(destination, segue: segue ?? destination.segue)
    }
    ///判断权限通过后加载
    public func load(_ destination: ECViewControllerType, segue: ECPresentSegue?, otherwise: (()->Void)?) {
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
