//
//  ViewController.swift
//  FXFramework
//
//  Created by Fanxx on 2019/6/10.
//  Copyright © 2019 fanxx. All rights reserved.
//

import UIKit
@_exported import EasyCoding
import Moya
import Result

class ViewController<PageType:UIView>: ECViewController<PageType>, ECFlowControllerType, NavigationControllerDelegate {
    
    var onFlow: ((ECFlowStep.State) -> Void)?
    ///关闭时的流程状态
    var onCloseFlowState : ECFlowStep.State {
        return .success
    }
    var customizeNavigationBack: ((@escaping ()->Void)->Void)?
    
    override var preconditions: [ECViewControllerPrecondition]? {
        return nil
    }
    ///默认是PUSH
    override var segue: ECPresentSegue{
        return .push
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    var isNaviagtionBarHidden: Bool {
        return false
    }
    var hidesNavigationBarBottomLine: Bool {
        return true //self.navigationBarColor != nil
    }
    var hidesNavigationAnimated: Bool {
        return true
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //设置返回按钮
        if self != self.navigationController?.viewControllers.first {
            let backButton = UIBarButtonItem(image: UIImage(named:"返回按钮图片"), style: .plain, target: self, action: #selector(self.onNavigationBack))
            self.navigationItem.leftBarButtonItem = backButton
        }
        if let rightBarButton = (self.page as? Page)?.rightBarButton {
            self.navigationItem.rightBarButtonItem = rightBarButton
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !self.hidesNavigationBarBottomLine {
            //presented的不影响
            if self.presentedViewController == nil {
                self.navigationController?.navigationBar.shadowImage = UINavigationBar.appearance().shadowImage
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        /*
        if self.hidesNavigationBar {
            //presented的不影响
            if self.presentedViewController == nil {
                self.navigationController?.setNavigationBarHidden(false, animated: self.hidesNavigationAnimated)
            }
        }*/
        if !self.hidesNavigationBarBottomLine {
            //presented的不影响
            if self.presentedViewController == nil {
                self.navigationController?.navigationBar.shadowImage = UIImage()
            }
        }
    }
    @objc func onNavigationBack() {
        if let action = self.customizeNavigationBack {
            action({
                self.onClose(state: .cancel)
            })
        }else{
            self.onClose(state: .cancel)
        }
    }
    
    @objc func onNavigationRight() {
        
    }
    override func onClose() {
        self.onClose(state: self.onCloseFlowState)
    }
    func onClose(state: ECFlowStep.State) {
        if self.easy.currentSegue != nil {
            super.onClose()
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        self.onFlow?(state)
    }
}
