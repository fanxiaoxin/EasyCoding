//
//  MainController.swift
//  EasyCoding_Example
//
//  Created by 范晓鑫 on 2021/2/10.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit

class MainController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let easy = UINavigationController(rootViewController: EasyController())
        let easy2 = UINavigationController(rootViewController: EasyController())
        
        let vs = [easy, easy2]
        
        self.viewControllers = vs
        
        for item in self.tabBar.items! {
            item.image = UIImage(named: "未选图片")
            item.selectedImage = UIImage(named: "选中图片")
        }
    }
}
