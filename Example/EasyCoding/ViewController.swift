//
//  ViewController.swift
//  EasyCoding
//
//  Created by fanxiaoxin_1987@126.com on 06/02/2020.
//  Copyright (c) 2020 fanxiaoxin_1987@126.com. All rights reserved.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        TEST().haha()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

@_functionBuilder
struct AttributedStringBuilder {
    static func buildBlock() -> NSAttributedString {
        return NSAttributedString(string: "I'm Default")
    }
  static func buildBlock(_ segments: NSAttributedString...) -> NSAttributedString {
    let string = NSMutableAttributedString()
    segments.forEach { string.append($0) }
    return string
  }
static func buildBlock(_ string: String,_ color: UIColor) -> NSAttributedString {
    return NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor : color])
  }
}
extension NSAttributedString {
  convenience init(@AttributedStringBuilder _ content: () -> NSAttributedString) {
    self.init(attributedString: content())
  }
}

class TEST {
    func haha() {
        let hello = NSAttributedString(string: "Hello")
        let world = NSAttributedString(string: "World")
       let str =
        NSAttributedString {
          hello
          world
        }
        print(str)
        let str2 = NSAttributedString{
            "fuck you"
            UIColor.red
        }
        print(str2)
        let str3 = NSAttributedString { () -> NSAttributedString in
            "SHit"
            UIColor.blue
        }
        print(str3)
    }
}
