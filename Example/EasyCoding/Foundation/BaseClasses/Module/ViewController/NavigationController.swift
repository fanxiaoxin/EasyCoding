//
//  NavigationController.swift
//  FXFramework
//
//  Created by Fanxx on 2019/6/10.
//  Copyright © 2019 fanxx. All rights reserved.
//

import UIKit
import EasyCoding

protocol NavigationControllerDelegate {
    var isNaviagtionBarHidden: Bool { get }
}

class NavigationController:ECNavigationController, UINavigationControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
    }
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let vc = viewController as? NavigationControllerDelegate, vc.isNaviagtionBarHidden {
            navigationController.setNavigationBarHidden(true, animated: true)
        }else{
            //系统相册继承自 UINavigationController 这个不能隐藏 所有就直接return
            if (navigationController.isKind(of: UIImagePickerController.self)) {
                return
            }
            //不在本页时，显示真正的navbar
            navigationController.setNavigationBarHidden(false, animated: true)
            //当不显示本页时，要么就push到下一页，要么就被pop了，那么就将delegate设置为nil，防止出现BAD ACCESS
            //之前将这段代码放在viewDidDisappear和dealloc中，这两种情况可能已经被pop了，self.navigationController为nil，这里采用手动持有navigationController的引用来解决
//            if(navigationController.delegate === self){
                //如果delegate是自己才设置为nil，因为viewWillAppear调用的比此方法较早，其他controller如果设置了delegate就可能会被误伤
//                navigationController.delegate = nil;
//        }
        }
    }
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if (navigationController.viewControllers.count > 1)
         {
//              navigationController.interactivePopGestureRecognizer?.delegate = self
             navigationController.interactivePopGestureRecognizer?.isEnabled = true;
         }
         else
         {
//              navigationController.interactivePopGestureRecognizer?.delegate = nil
             navigationController.interactivePopGestureRecognizer?.isEnabled = false;
         }
    }
}
