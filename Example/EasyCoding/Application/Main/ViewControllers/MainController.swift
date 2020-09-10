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


