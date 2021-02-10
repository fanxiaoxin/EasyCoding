//
//  UIScrollViewExtension.swift
//  Alamofire
//
//  Created by Fanxx on 2019/7/26.
//

import UIKit

extension EasyCoding where Base: UIScrollView {
    public var currentPage: Int {
        //出现过相差5的情况，暂无找到原因，先加10，若低于10则止方法不适用
        return Int((self.base.contentOffset.x + 10) / self.base.bounds.size.width)
    }
    public func scrollToTop(animated: Bool = true ) {
        var off = self.base.contentOffset
        off.y = 0 - self.base.contentInset.top
        self.base.setContentOffset(off, animated: animated)
    }
}
