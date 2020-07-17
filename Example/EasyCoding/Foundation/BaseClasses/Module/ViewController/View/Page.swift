//
//  Page.swift
//  FXFramework
//
//  Created by Fanxx on 2019/6/10.
//  Copyright © 2019 fanxx. All rights reserved.
//

import UIKit
@_exported import EasyCoding

class Page: ECPage, ECPageEventDelegate {
    var rightBarButton: UIBarButtonItem?
    var rightBarEvent: String = "NavigationRight"
    override func load() {
        super.load()
        
        self.easy.style(.bg(.white))
    }
    func triget(editing event: String, params: Any? = nil) {
        super.triget(event: event, params: params)
    }
    override func triget(event name: String, params: Any? = nil) {
        self.endEditing(true)
        super.triget(event: name, params: params)
    }
    func forwardEvent(_ name: String, params: Any?) {
        self.eventDelegate?.performEvent(name, params: params)
    }
    ///导航右功能
    func navigationRight(_ title:String,_ event: String? = nil) {
        let item = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(self.rightBarAction))
        if let e = event {
            self.rightBarEvent = e
        }
        self.rightBarButton = item
    }
    func navigationRight(image named:String,_ event: String? = nil) {
        let item = UIBarButtonItem(image: UIImage(named: named), style: .plain, target: self, action: #selector(self.rightBarAction))
        if let e = event {
            self.rightBarEvent = e
        }
        self.rightBarButton = item
    }
    @objc func rightBarAction() {
        self.triget(event: self.rightBarEvent)
    }
}
class ListPage: Page {
    let tableView = UITableView()
}
class DefaultListPage: ListPage {
    override func load() {
        super.load()
        
        self.easy.add(tableView.easy(.row(height: 44)), layout: .margin)
    }
}
