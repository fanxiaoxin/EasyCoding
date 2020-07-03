//
//  TestSettingManager.swift
//  MJRefresh
//
//  Created by Fanxx on 2019/7/31.
//

import UIKit

open class ECTestSettingManager {
    public let controller: UINavigationController
    public let filePath: String
    public init() {
        self.filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "ECSettingManager.plist"
        let sc = ECTestSettingController()
        sc.title = "配置文件"
        self.controller = UINavigationController(rootViewController: sc)
        
        let items = self.configable()
        sc.items = items
        sc.selectAction = { item in
            if self.onSelected(item: item) {
                let plist = NSMutableDictionary(contentsOfFile: self.filePath) ?? NSMutableDictionary()
                plist[item.name] = item.value
                plist.write(toFile: self.filePath, atomically: false)
            }
        }
        sc.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.hide))
    }
    open func load() {
        let plist = NSDictionary(contentsOfFile: self.filePath)
        let items = (controller.viewControllers[0] as! ECTestSettingController).items!
        for item in items {
            if let v = plist?[item.name] {
                item.value = v
            }
            self.onSelected(item: item)
        }
    }
    open func hook(in view:UIView) {
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.show(sender:)))
        gesture.edges = .right
        view.addGestureRecognizer(gesture)
    }
    @objc func show(sender:UIScreenEdgePanGestureRecognizer) {
        if sender.state == .ended {
            self.show()
        }
    }
    @objc open func show() {
        controller.easy.showWindow(animation: ECPresentAnimation.Popup())
    }
    @objc open func hide() {
        controller.easy.dismissWindow()
    }
    open func configable() -> [ECTestSettingItem] {
        return []
    }
    @discardableResult
    open func onSelected(item:ECTestSettingItem) -> Bool {
        return true
    }
}
