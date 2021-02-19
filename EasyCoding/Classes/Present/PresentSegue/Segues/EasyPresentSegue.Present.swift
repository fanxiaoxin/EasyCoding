//
//  Present.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/3.
//

import UIKit

extension EasyPresentSegue {
    ///从下往上弹
    public class Present: EasyPresentSegue {
        public let isAnimated: Bool
        public init(animated: Bool = true) {
            self.isAnimated = animated
            super.init()
        }
        open override func performAction(completion: (() -> Void)?) {
            if let s = self.source, let d = self.destination {
                s.present(d, animated: self.isAnimated, completion: completion)
            }
        }
        public override func unwindAction() {
            self.destination?.dismiss(animated: self.isAnimated, completion: nil)
        }
    }
    public static var present: Present { return Present() }
}
