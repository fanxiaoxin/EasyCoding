
//
//  UILabelExtension.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/8/15.
//

import UIKit

extension EasyCoding where Base: UILabel {
    ///获取在某个点上的文字索引，可用于点击事件根据对应的文字做不同的操作
    public func characterIndex(at point: CGPoint) -> Int? {
        if let text = self.base.attributedText {
            let ps = NSMutableParagraphStyle()
            ps.lineBreakMode = self.base.lineBreakMode
            let at = NSMutableAttributedString(attributedString: text)
            let range = NSMakeRange(0, at.length)
            at.addAttributes([.paragraphStyle: ps], range: range)
            if let f = self.base.font {
                at.addAttributes([.font: f], range: range)
            }
            
            return at.easy.characterIndex(at: point, for: self.base.bounds.size, numberOfLines: self.base.numberOfLines)
        }
        return nil
    }
}
