//
//  PresentSegue.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/6/4.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import UIKit

open class EasyPresentSegue: EasyPresentSegueType {
    
    public weak var source: UIViewController?
    public weak var destination: UIViewController?
    
    open func performAction(completion: (() -> Void)?) {
        
    }
    open func unwindAction() {
        
    }
    open func performNext(segue: EasyPresentSegueType, completion: (() -> Void)?) {
        segue.performAction(completion: completion)
    }
    public init() {
        
    }
}
