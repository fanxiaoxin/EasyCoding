//
//  UITableViewExtension.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/6/11.
//

import UIKit

//extension UINavigationController: EasyNamespaceWrappable {}
extension EasyCoding where Base: UITableView {
    public func selectAll() {
        let sections = self.base.numberOfSections
        for i in 0..<sections {
            let rows = self.base.numberOfRows(inSection: i)
            for j in 0..<rows {
            let indexPath = IndexPath(row: j, section: i)
                self.base.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
        }
    }
    public func deselectAll() {
        if let ips = self.base.indexPathsForSelectedRows {
            for ip in ips {
                self.base.deselectRow(at: ip, animated: false)
            }
        }
    }
}
