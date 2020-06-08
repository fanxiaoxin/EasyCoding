//
//  FunctionBuilderTest.swift
//  EasyCoding_Example
//
//  Created by JY_NEW on 2020/6/3.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit


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
    static func buildIf(_ string: NSAttributedString?) -> NSAttributedString  {
        return string ?? NSAttributedString(string: " Nothing")
    }
    static func buildEither(first: NSAttributedString) -> NSAttributedString {
        return first
    }
    static func buildEither(second: NSAttributedString) -> NSAttributedString {
        return second
    }
}
extension NSAttributedString {
  convenience init(@AttributedStringBuilder _ content: (Int) -> NSAttributedString) {
    self.init(attributedString: content(3))
  }
}

class TEST {
    func haha() {
        let hello = NSAttributedString(string: "Hello")
        let world = NSAttributedString(string: "World")
        let test1 = false
        let test2 = true
       let str =
        NSAttributedString {i in
            hello
            world
            if test1 {
                world
            }
            if test2 {
                hello
            }else{
                world
            }
        }
        print(str)
        let str2 = NSAttributedString{i in
            "fuck you\(i)"
            UIColor.red
        }
        print(str2)
        let str3 = NSAttributedString { (_) -> NSAttributedString in
            "SHit"
            UIColor.blue
        }
        print(str3)
    }
}
