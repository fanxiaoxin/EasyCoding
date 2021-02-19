//
//  Content.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/3.
//

import UIKit

extension EasyPresentSegue {
    ///指定加载到某个View，这个场景只能由调用方使用，因为被调用方无法固定要加载的View
    public class Content: EasyPresentSegue {
        public let view: UIView
        public let config: EasyCustomControlConfig<UIView>
        public init(view: UIView) {
            self.view = view
            self.config = EasyCustomControlConfig<UIView>(layouts: [.margin])
            super.init()
        }
        open override func performAction(completion: (() -> Void)?) {
            if let s = self.source, let d = self.destination {
                s.addChild(d)
                self.view.addSubview(d.view)
                self.config.apply(for: d.view)
                if let animation = self.config.presentAnimation {
                    animation.show(view: d.view, completion: completion)
                }else{
                    completion?()
                }
            }
        }
        public override func unwindAction() {
            if let view = self.destination?.view, let animation = self.config.presentAnimation {
                animation.dismiss(view: view) {[weak self] in
                    self?.destination?.view.removeFromSuperview()
                    self?.destination?.removeFromParent()
                }
            }
        }
    }
}
