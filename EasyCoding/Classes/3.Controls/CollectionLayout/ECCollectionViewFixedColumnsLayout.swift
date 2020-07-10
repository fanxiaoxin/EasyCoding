//
//  CollectionViewFixedColumnsLayout.swift
//  ECKit
//
//  Created by Fanxx on 2019/11/6.
//

import UIKit

///固定列数
open class ECCollectionViewFixedColumnsLayout: UICollectionViewLayout {
    public enum LineAlignment {
        case top
        case bottom
        case center
        case none
    }
    ///边距
    public var padding: UIEdgeInsets = .zero
    ///间距
    public var spacing: CGPoint = .zero
    ///列数
    public var numberOfColumns: Int = 2
    ///行对齐，默认顶部对齐，不对齐则乱序
    public var lineAlignment: LineAlignment = .top
    ///高度，可根据宽度获取，不设则默认正方型
    public var heightForWidth: (_ width: CGFloat, _ indexPath: IndexPath) -> CGFloat = { width, _ in width }
    
    //CollectionView会在初次布局时首先调用该方法
    //CollectionView会在布局失效后、重新查询布局之前调用此方法
    //子类中必须重写该方法并调用超类的方法
    private var __attributes : [UICollectionViewLayoutAttributes]?
    private var __itemWidth: CGFloat = 0
    private var __lastColHeights: [CGFloat] = []
    private var __lastRowAttributes: [UICollectionViewLayoutAttributes] = []
    open override func prepare() {
        super.prepare()
        
        if let width = self.collectionView?.bounds.size.width {
            let w = (width - self.padding.left - self.padding.right + self.spacing.x) / CGFloat(self.numberOfColumns) - self.spacing.x
            self.__itemWidth = w
        }else{
            self.__itemWidth = 0
        }
        
        if let collectionView = self.collectionView, collectionView.numberOfSections > 0 {
            var attrs: [UICollectionViewLayoutAttributes] = []
            ///初始化每一列的最大高度
            __lastColHeights = .init(repeating: self.padding.top, count: self.numberOfColumns)
            if self.lineAlignment == .none {
                //无序特殊处理
                var col = 0
                self.forEachIndexPaths(for: collectionView) { (indexPath) in
                    ///换Section时重设高度
                    if indexPath.row == 0 {
                        let max = __lastColHeights.max() ?? self.padding.top
                        for i in 0..<__lastColHeights.count { __lastColHeights[i] = max }
                        //重置列
                        col = 0
                    }
                    let att = self.prepareDisorderLayoutAttributesForItem(at: indexPath, col: col)
                    attrs.append(att.0)
                    //记录最后一行的数据和每列高度
                    self.__lastColHeights[att.1] = att.0.frame.origin.y + att.0.frame.size.height + spacing.y
                    if att.1 >= self.numberOfColumns - 1 {
                        col = 0
                    }else{
                        col = att.1 + 1
                    }
                }
                self.aligLastRowFrame()
            }else{
                //有序统一处理
                self.forEachIndexPaths(for: collectionView) { (indexPath) in
                    let col = indexPath.row % self.numberOfColumns
                    ///换Section或换行时重设高度
                    if col == 0 {
                        let max = __lastColHeights.max() ?? self.padding.top
                        for i in 0..<__lastColHeights.count { __lastColHeights[i] = max }
                        ///对齐上一行的布局
                        self.aligLastRowFrame()
                        //每换一行清空
                        self.__lastRowAttributes.removeAll()
                    }
                    //该方法全部往上面对齐排
                    let att = self.prepareOrderlyLayoutAttributesForItem(at: indexPath)
                    attrs.append(att)
                    //记录最后一行的数据和每列高度
                    self.__lastRowAttributes.append(att)
                    self.__lastColHeights[col] = att.frame.origin.y + att.frame.size.height + spacing.y
                }
                self.aligLastRowFrame()
            }
            __attributes = attrs
        }else{
            __attributes = nil
        }
    }
    func forEachIndexPaths(for collectionView: UICollectionView, block: (IndexPath) -> Void) {
        for i in 0..<collectionView.numberOfSections {
            for j in 0..<collectionView.numberOfItems(inSection: i) {
                block(IndexPath(item: j, section: i))
            }
        }
    }
    ///对齐最后一行
    func aligLastRowFrame() {
        //最后一行重设对齐
        switch self.lineAlignment {
        case .center:
            let max = __lastColHeights.max() ?? self.padding.top + self.spacing.y
            for attribute in self.__lastRowAttributes {
                attribute.frame.origin.y += (max - self.spacing.y - attribute.frame.origin.y - attribute.frame.size.height) / 2
            }
        case .bottom:
            let max = __lastColHeights.max() ?? self.padding.top + self.spacing.y
            for attribute in self.__lastRowAttributes {
                attribute.frame.origin.y += max - self.spacing.y -  attribute.frame.origin.y - attribute.frame.size.height
            }
        default: break
        }
    }
    ///有序列表, lineAligment == .top, .bottom, .center
    open func prepareOrderlyLayoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        let size = CGSize(width: self.__itemWidth, height: self.heightForWidth(self.__itemWidth, indexPath))
        
        let col = indexPath.row % self.numberOfColumns
        let origin = CGPoint(x: padding.left + CGFloat(col) * (__itemWidth + spacing.x), y: __lastColHeights[col])
        attribute.frame = CGRect(origin: origin, size: size)
        
        return attribute
    }
    ///无序列表, lineAligment == .none
    open func prepareDisorderLayoutAttributesForItem(at indexPath: IndexPath, col: Int) -> (UICollectionViewLayoutAttributes, Int) {
        let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        let size = CGSize(width: self.__itemWidth, height: self.heightForWidth(self.__itemWidth, indexPath))
       
        var targetCol = col
        //最大和最小的差值
        let max = __lastColHeights.max() ?? 0
        let min = __lastColHeights.min() ?? 0
        let diff = max - min
        
        //当最大和最小的高度差大于目标的一半时，把目标塞进去
        if diff > size.height / 2 {
            for i in 0..<__lastColHeights.count {
                //从当前列往后循环再折回前面
                let index = (i + col) % __lastColHeights.count
                let height = __lastColHeights[index]
                //若刚好是最小的,则直接放进去
                if height == min {
                    targetCol = index
                    break
                }
                //否则只要碰到超过1半大小的就放进去
                if max - height > size.height / 2 {
                    targetCol = index
                    break
                }
            }
        }

        let origin = CGPoint(x: padding.left + CGFloat(targetCol) * (__itemWidth + spacing.x), y: __lastColHeights[targetCol])
        attribute.frame = CGRect(origin: origin, size: size)
        
        return (attribute, targetCol)
    }
    //子类必须重写此方法。
    //并使用它来返回CollectionView视图内容的宽高，
    //这个值代表的是所有的内容的宽高，并不是当前可见的部分。
    //CollectionView将会使用该值配置内容的大小来促进滚动。
    open override var collectionViewContentSize: CGSize {
        if let cv = self.collectionView {
            let width = cv.bounds.size.width
            ///最后一个cell的底部加上边距就是高度
            let max = __lastColHeights.max() ?? self.padding.top + spacing.y
            let height = max - spacing.y + self.padding.bottom
            return CGSize(width: width, height: height)
        }
        return .zero
    }
    ///返回UICollectionViewLayoutAttributes 类型的数组，
    ///UICollectionViewLayoutAttributes 对象包含cell或view的布局信息。
    ///子类必须重载该方法，并返回该区域内所有元素的布局信息，包括cell,追加视图和装饰视图。
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.__attributes
    }
    ///返回指定indexPath的item的布局信息。子类必须重载该方法,该方法
    ///只能为cell提供布局信息，不能为补充视图和装饰视图提供。
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        var index: Int = 0
        for i in 0..<indexPath.section {
            index += self.collectionView?.numberOfItems(inSection: i) ?? 0
        }
        index += indexPath.row
        return __attributes?[index]
    }
    /*
     ///如果你的布局支持追加视图的话，必须重载该方法，该方法返回的是
     追加视图的布局信息，kind这个参数区分段头还是段尾的，在collectionview注册的时候回用到该参数。
     open override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
     
     }
     ///如果你的布局支持装饰视图的话，必须重载该方法，该方法返回的是装饰视图的布局信息，
     ecorationViewKind这个参数在collectionview注册的时候回用到
     open override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
     
     }*/
    
    //当Bounds改变时，返回YES使CollectionView重新查询几何信息的布局
    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        ///View改变了大小才要重新布局
        if newBounds.size != self.collectionView?.bounds.size {
            return true
        }
        return false
    }
}
