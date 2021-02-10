//
//  ExtensionHeader.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/4/22.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import UIKit

extension NSObject: EasyExtension {}
extension URL: EasyExtension {}
extension String: EasyExtension { }
extension Date: EasyExtension { }
//extension NSAttributedString.Key: EasyExtension {}

extension Array: EasyArrayExtension {}
extension Dictionary: EasyDictionaryExtension {}

extension CGFloat: EasyExtension { }
extension Decimal: EasyExtension { }
extension UIEdgeInsets: EasyExtension {}
extension CGRect: EasyExtension { }
extension CGSize: EasyExtension { }
extension CGPoint: EasyExtension { }
