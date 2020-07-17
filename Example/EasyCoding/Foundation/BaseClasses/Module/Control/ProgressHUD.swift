//
//  ProgressHUD.swift
//  EasyCoding_Example
//
//  Created by JY_NEW on 2020/7/11.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import EasyCoding

class ProgressHUD: ECLoadingView {
    static let animation = ECPresentAnimation.Fade()
    class func showAdded(to target: UIView) -> ProgressHUD {
        let hud = ProgressHUD()
        target.easy.add(hud, layout: .center)
        hud.easy.show(animation: self.animation)
        return hud
    }
    func hide() {
        self.easy.dismiss { [weak self] in
            self?.removeFromSuperview()
        }
    }
}
extension UIView {
    var hud:ProgressHUD? {
        get{
            return self.easy.getAssociated(object: "ProgressHUD")
        }
        set{
            self.easy.setAssociated(object: newValue, key: "ProgressHUD")
        }
    }
    var isHUDShowing : Bool {
        return self.hud != nil
    }
    func showHUD(){
        if let hud = self.hud {
            hud.tag += 1
        }else{
            let hud = ProgressHUD.showAdded(to: self)
            hud.tag = 0
            self.hud = hud
        }
    }
    func hideHUD(){
        if let hud = self.hud {
            if hud.tag == 0 {
                hud.hide()
                self.hud = nil
            }else{
                hud.tag -= 1
            }
        }
    }
    func hideAllHUD(){
        if let hud = self.hud {
            hud.hide()
            self.hud = nil
        }
    }
}
