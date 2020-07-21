//
//  ViewControllerAccessable.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/11/23.
//

import UIKit

public protocol ECViewControllerAccessable {
    ///加载视图的源视图
    var accessSourceViewController: UIViewController { get }
    ///加载目标视图
    func load(_ destination: ECViewControllerType, segue: ECPresentSegue?, otherwise: (()->Void)?)
}
extension ECViewControllerAccessable {
    ///加载视图的源视图
    public var accessSourceViewController: UIViewController { return UIViewController.easy.current! }

    public func load(_ destination: ECViewControllerType, segue: ECPresentSegue? = nil) {
        self.load(destination, segue: segue, otherwise: nil)
    }
    public func load(_ destination: ECViewControllerType, otherwise: (()->Void)?) {
        self.load(destination, segue: nil, otherwise: otherwise)
    }
}
///实现load方法
extension ECViewControllerAccessable {
    private func check(preconditions destination: ECViewControllerType, pass: @escaping ()->Void) {
        self.check(preconditions: destination, pass: pass, otherwise: nil)
    }
    private func check(preconditions destination: ECViewControllerType, pass: @escaping ()->Void, otherwise: (()->Void)?) {
        if let cs = destination.preconditions {
            self.check(conditions: cs, pass: pass, otherwise: otherwise)
        }else{
            pass()
        }
    }
    ///私有方法，用于前置权限的检查
    private func check(conditions:[ECViewControllerPrecondition], pass: @escaping ()->Void, otherwise: (()->Void)?) {
        if conditions.count > 0 {
            var newCs = conditions
            let cdt = newCs.removeFirst()
            cdt.failureHandler = otherwise
            let source = self.accessSourceViewController
            ECViewControllerAccessCenter.shared.check(condition: cdt, input: source) { [weak source] (_) in
                source?.check(conditions: newCs, pass: pass, otherwise: otherwise)
            }
        }else{
            pass()
        }
    }
    ///不判断前提要求，直接加载
    public func directLoad(_ destination: ECViewControllerType, segue: ECPresentSegue? = nil) {
        self.accessSourceViewController.easy.present(destination, segue: segue ?? destination.segue)
    }
    ///判断权限通过后加载
    public func load(_ destination: ECViewControllerType, segue: ECPresentSegue?, otherwise: (()->Void)?) {
        let source = self.accessSourceViewController
        self.check(preconditions: destination, pass: { [weak source] in
            source?.directLoad(destination, segue: segue)
        }, otherwise: otherwise)
    }
}
///UIViewController使用自身
extension UIViewController: ECViewControllerAccessable {
    ///加载视图的源视图
    public var accessSourceViewController: UIViewController { return self }
}

extension ECViewControllerType {
    ///关闭页面
    public func unload() {
        self.easy.dismiss()
    }
}

extension ECPrecondition: ECViewControllerAccessable where InputType: UIViewController {
    public var accessSourceViewController: UIViewController { return self.currentController! }
}

extension ECPrecondition where InputType: UIViewController {
    ///重定向到新视图，自身不显示
    public func redirect(to controller: ECViewControllerType, segue: ECPresentSegue? = nil, otherwise: (() -> Void)? = nil) {
        self.load(controller, segue: segue, otherwise: otherwise)
        self.finished(false)
    }
}
