//
//  ViewControllerAccessable.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/11/23.
//

import UIKit

public protocol ECViewControllerAccessable {
    func load(_ destination: ECViewControllerType, segue: ECPresentSegue?, otherwise: (()->Void)?)
}

extension UIViewController: ECViewControllerAccessable {
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
            ECViewControllerAccessCenter.shared.check(condition: cdt, input: self) { [weak self] (_) in
                self?.check(conditions: newCs, pass: pass, otherwise: otherwise)
            }
        }else{
            pass()
        }
    }
    ///不判断前提要求，直接加载
    public func directLoad(_ destination: ECViewControllerType, segue: ECPresentSegue? = nil) {
        self.easy.present(destination, segue: segue ?? destination.segue)
    }
    ///判断权限通过后加载
    public func load(_ destination: ECViewControllerType, segue: ECPresentSegue?, otherwise: (()->Void)?) {
        self.check(preconditions: destination, pass: { [weak self] in
            self?.directLoad(destination, segue: segue)
        }, otherwise: otherwise)
    }
}
extension ECViewControllerType {
    ///关闭页面
    public func unload() {
        self.easy.dismiss()
    }
}

extension ECViewControllerAccessable {
    public func load(_ destination: ECViewControllerType, segue: ECPresentSegue?, otherwise: (()->Void)?) {
        UIViewController.easy.current?.load(destination, segue: segue, otherwise: otherwise)
    }
}
extension ECViewControllerAccessable {
    public func load(_ destination: ECViewControllerType, segue: ECPresentSegue? = nil) {
        self.load(destination, segue: segue, otherwise: nil)
    }
    public func load(_ destination: ECViewControllerType, otherwise: (()->Void)?) {
        self.load(destination, segue: nil, otherwise: otherwise)
    }
}
extension ECPrecondition: ECViewControllerAccessable where InputType: UIViewController {
    public func load(_ destination: ECViewControllerType, segue: ECPresentSegue?, otherwise: (() -> Void)?) {
        (self.input ?? UIViewController.easy.current)?.load(destination, segue: segue, otherwise: otherwise)
    }
}
