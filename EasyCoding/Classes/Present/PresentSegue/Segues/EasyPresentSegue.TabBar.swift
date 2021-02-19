//
//  TabBar.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/3.
//

import UIKit

extension EasyPresentSegue {
    ///附加到TabbarController上
    public class TabBar: EasyPresentSegue {
        public let title: String?
        public let icon: UIImage?
        public let selectedIcon: UIImage?
        public init(title: String?, icon:UIImage?,selected: UIImage?) {
            self.title = title
            self.icon = icon
            self.selectedIcon = selected
            super.init()
        }
        public convenience init(title: String?, iconNamed:String,selectedNamed: String?) {
            let icon = UIImage(named: iconNamed)?.withRenderingMode(.alwaysOriginal)
            let selected: UIImage?
            if let s = selectedNamed {
                selected = UIImage(named: s)?.withRenderingMode(.alwaysOriginal)
            }else{
                selected = nil
            }
            self.init(title: title, icon: icon, selected: selected)
        }
        
        open override func performAction(completion: (() -> Void)?) {
            if let tab = self.source as? UITabBarController, let d = self.destination {
                if var cs = tab.viewControllers {
                    cs.append(d)
                    tab.viewControllers = cs
                }else{
                    tab.viewControllers = [d]
                }
                let index = tab.viewControllers!.count - 1
                tab.tabBar.items![index].title = title
                tab.tabBar.items![index].image = icon
                tab.tabBar.items![index].selectedImage = selectedIcon
                completion?()
            }
        }
        public override func unwindAction() {
            if let d = self.destination, let tab = d.tabBarController {
                if let index = tab.viewControllers?.firstIndex(of: d) {
                    tab.viewControllers!.remove(at: index)
                }
            }
        }
    }
}
