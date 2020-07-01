//
//  ECDataLoadingDecorator.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/30.
//

import UIKit

open class ECDataLoadingPlugin<DataType>: ECDataLoadingPluginBase<DataType> {
    deinit {
        print(NSStringFromClass(Self.self) + "die")
    }
    ///要加载到的页面，若为空则加载到keywindow
    open weak var targetView: UIView?
    ///加载页
    open lazy var loadingView: UIView = {
        return ECLoadingView()
    }()
    open override func load() {
        if let target = self.targetView ?? UIApplication.shared.keyWindow {
            if let superView = self.loadingView.superview, superView == target {
                self.loadingView.tag += 1
            }else{
                self.loadingView.tag = 0
                target.easy.add(self.loadingView, layout: .center)
            }
        }
    }
    open override func unload() {
        if self.loadingView.tag == 0 {
            self.loadingView.removeFromSuperview()
        }else{
            self.loadingView.tag -= 1
        }
    }
}
