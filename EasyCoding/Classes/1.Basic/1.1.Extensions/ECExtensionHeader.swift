//
//  ExtensionHeader.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/4/22.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import UIKit

extension NSObject: EC.NamespaceDefine {}
extension URL: EC.NamespaceDefine {}
extension String: EC.NamespaceDefine { }
extension Date: EC.NamespaceDefine { }
//extension NSAttributedString.Key: EC.NamespaceDefine {}

extension Array: EC.NamespaceArrayDefine {}
extension Dictionary: EC.NamespaceDictionaryDefine {}

extension CGFloat: EC.NamespaceDefine { }
extension Decimal: EC.NamespaceDefine { }
extension UIEdgeInsets: EC.NamespaceDefine {}
extension CGRect: EC.NamespaceDefine { }
extension CGSize: EC.NamespaceDefine { }
extension CGPoint: EC.NamespaceDefine { }
