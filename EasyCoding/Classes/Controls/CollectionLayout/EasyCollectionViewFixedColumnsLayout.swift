//
//  CollectionViewFixedColumnsLayout.swift
//  EasyKit
//
//  Created by Fanxx on 2019/11/6.
//

import UIKit

///固定列数
open class EasyCollectionViewFixedColumnsLayout: UICollectionViewLayout {
    public typealias HeightForWidth = (_ width: CGFloat, _ indexPath: IndexPath) -> CGFloat
    public enum LineAlignment {
        case top
        case bottom
        case center
        case none
    }
    ///边距
    open var padding: UIEdgeInsets = .zero
    ///间距
    open var spacing: CGPoint = .zero
    ///列数
    open var numberOfColumns: Int = 2
    ///行对齐，默认顶部对齐，不对齐则乱序
    open var lineAlignment: LineAlignment = .top
    ///高度，可根据宽度获取，不设则默认正方型
    open var heightForWidth: HeightForWidth = { width, _ in width }
    ///Header高度，可根据宽度获取，不设则默认0
    open var headerHeightForWidth: HeightForWidth = { width, _ in 0 }
    ///Footer高度，可根据宽度获取，不设则默认0
    open var footerHeightForWidth: HeightForWidth = { width, _ in 0 }
    ///Section内边距
    open var sectionInset: UIEdgeInsets = .zero
    
    private var __cellAttributes : [UICollectionViewLayoutAttributes]?
    private var __headerAttributes : [UICollectionViewLayoutAttributes]?
    private var __footerAttributes : [UICollectionViewLayoutAttributes]?
    private var __itemWidth: CGFloat = 0
    private var __lastColHeights: [CGFloat] = []
    private var __lastRowAttributes: [UICollectionViewLayoutAttributes] = []
    //CollectionView会在初次布局时首先调用该方法
    //CollectionView会在布局失效后、重新查询布局之前调用此方法
    //子类中必须重写该方法并调用超类的方法
    open override func prepare() {
        super.prepare()
        
        if let width = self.collectionView?.bounds.size.width {
            let w = (width - self.padding.easy.leftRight - self.sectionInset.easy.leftRight + self.spacing.x) / CGFloat(self.numberOfColumns) - self.spacing.x
            self.__itemWidth = w
        }else{
            self.__itemWidth = 0
        }
        
        if let collectionView = self.collectionView, collectionView.numberOfSections > 0 {
            if self.lineAlignment == .none {
                let attrs = self.prepareDisorderLayoutAttributes(for: collectionView)
                __cellAttributes = attrs.cell
                __headerAttributes = attrs.header
                __footerAttributes = attrs.footer
            }else{
                let attrs = self.prepareOrderlyLayoutAttributes(for: collectionView)
                __cellAttributes = attrs.cell
                __headerAttributes = attrs.header
                __footerAttributes = attrs.footer
            }
        }else{
            __cellAttributes = nil
            __headerAttributes = nil
            __footerAttributes = nil
        }
    }
    ///计算有序布局
    open func prepareOrderlyLayoutAttributes(for collectionView: UICollectionView) -> (header: [UICollectionViewLayoutAttributes]?, cell: [UICollectionViewLayoutAttributes]?, footer: [UICollectionViewLayoutAttributes]?) {
        var attrs: [UICollectionViewLayoutAttributes] = []
        var headerAttrs: [UICollectionViewLayoutAttributes] = []
        var footerAttrs: [UICollectionViewLayoutAttributes] = []
        ///初始化每一列的最大高度
        __lastColHeights = .init(repeating: self.padding.top, count: self.numberOfColumns)
        self.__lastRowAttributes.removeAll()
        //有序统一处理
        self.forEachIndexPaths(for: collectionView, header: { indexPath in
            let max: CGFloat
            if let header = self.prepareSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath) {
                headerAttrs.append(header)
                max = header.frame.easy.bottom
            }else{
                max = __lastColHeights.max()!
            }
            //重设列的高度
            for i in 0..<__lastColHeights.count {
                __lastColHeights[i] = max + self.sectionInset.top
            }
        }, cell: { (indexPath) in
            let col = indexPath.row % self.numberOfColumns
            ///换行时重设高度
            if col == 0 && indexPath.row != 0 {
                let max = __lastColHeights.max()!
                for i in 0..<__lastColHeights.count {
                    __lastColHeights[i] = max
                }
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
            self.__lastColHeights[col] = att.frame.easy.bottom + spacing.y
        }, footer: { indexPath in
            //结束刷新布局
            let max = __lastColHeights.max()!
            for i in 0..<__lastColHeights.count {
                __lastColHeights[i] = max - self.spacing.y + self.sectionInset.bottom
            }
            ///对齐上一行的布局
            self.aligLastRowFrame()
            //每换一行清空
            self.__lastRowAttributes.removeAll()
            ///底部
            if let footer = self.prepareSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, at: indexPath) {
                footerAttrs.append(footer)
                //重设列的高度
                let max = footer.frame.easy.bottom
                for i in 0..<__lastColHeights.count {
                    __lastColHeights[i] = max
                }
            }
        })
        //对齐最后一行
        self.aligLastRowFrame()
        return (header: headerAttrs.count > 0 ? headerAttrs : nil,
                cell: attrs,
                footer: footerAttrs.count > 0 ? footerAttrs : nil)
    }
    ///计算无序布局
    open func prepareDisorderLayoutAttributes(for collectionView: UICollectionView) -> (header: [UICollectionViewLayoutAttributes]?, cell: [UICollectionViewLayoutAttributes]?, footer: [UICollectionViewLayoutAttributes]?) {
        var attrs: [UICollectionViewLayoutAttributes] = []
        var headerAttrs: [UICollectionViewLayoutAttributes] = []
        var footerAttrs: [UICollectionViewLayoutAttributes] = []
        ///初始化每一列的最大高度
        __lastColHeights = .init(repeating: self.padding.top, count: self.numberOfColumns)
        //无序特殊处理
        var col = 0
        self.forEachIndexPaths(for: collectionView, header: { indexPath in
            let max: CGFloat
            if let header = self.prepareSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath) {
                headerAttrs.append(header)
                max = header.frame.easy.bottom
            }else{
                max = __lastColHeights.max()!
            }
            //重设列的高度
            for i in 0..<__lastColHeights.count {
                __lastColHeights[i] = max + self.sectionInset.top
            }
        }, cell: { (indexPath) in
            let att = self.prepareDisorderLayoutAttributesForItem(at: indexPath, col: col)
            attrs.append(att.0)
            //记录最后一行的数据和每列高度
            self.__lastColHeights[att.1] = att.0.frame.origin.y + att.0.frame.size.height + spacing.y
            if att.1 >= self.numberOfColumns - 1 {
                col = 0
            }else{
                col = att.1 + 1
            }
        }, footer: { indexPath in
            ///换Section时重设高度
            let max = __lastColHeights.max()!
            for i in 0..<__lastColHeights.count {
                __lastColHeights[i] = max - self.spacing.y + self.sectionInset.bottom
            }
            //重置列
            col = 0
            ///底部
            if let footer = self.prepareSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, at: indexPath) {
                footerAttrs.append(footer)
                //重设列的高度
                let max = footer.frame.easy.bottom
                for i in 0..<__lastColHeights.count {
                    __lastColHeights[i] = max
                }
            }
        })
        return (header: headerAttrs.count > 0 ? headerAttrs : nil,
                cell: attrs,
                footer: footerAttrs.count > 0 ? footerAttrs : nil)
    }
    open func forEachIndexPaths(for collectionView: UICollectionView, header: (IndexPath) -> Void, cell: (IndexPath) -> Void, footer: (IndexPath) -> Void) {
        for i in 0..<collectionView.numberOfSections {
            let items = collectionView.numberOfItems(inSection: i)
            header(IndexPath(item: 0, section: i))
            for j in 0..<items {
                cell(IndexPath(item: j, section: i))
            }
            footer(IndexPath(item: max(items - 1, 0), section: i))
        }
    }
    ///对齐最后一行
    func aligLastRowFrame() {
        //最后一行重设对齐
        switch self.lineAlignment {
        case .center:
            let max = __lastColHeights.max() ?? self.padding.top + self.sectionInset.top + self.spacing.y
            for attribute in self.__lastRowAttributes {
                attribute.frame.origin.y += (max - self.spacing.y - attribute.frame.origin.y - attribute.frame.size.height) / 2
            }
        case .bottom:
            let max = __lastColHeights.max() ?? self.padding.top + self.sectionInset.top + self.spacing.y
            for attribute in self.__lastRowAttributes {
                attribute.frame.origin.y += max - self.spacing.y -  attribute.frame.origin.y - attribute.frame.size.height
            }
        default: break
        }
    }
    ///头部底部
    open func prepareSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if let boundWidth = self.collectionView?.bounds.size.width {
            let width = boundWidth - self.padding.easy.leftRight
            let height: CGFloat
            switch elementKind {
            case UICollectionView.elementKindSectionHeader: height = self.headerHeightForWidth(width, indexPath)
            case UICollectionView.elementKindSectionFooter: height = self.footerHeightForWidth(width, indexPath)
            default: height = 0
            }
            if height > 0 {
                let attribute = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
                let size = CGSize(width: width, height: height)
                
                //在调用该方法前应该先将所有高度重置为最高值，所以此处只取第1个
                let origin = CGPoint(x: padding.left, y: __lastColHeights[0])
                attribute.frame = CGRect(origin: origin, size: size)
                
                return attribute
            }
        }
        return nil
    }
    ///有序列表, lineAligment == .top, .bottom, .center
    open func prepareOrderlyLayoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        let size = CGSize(width: self.__itemWidth, height: self.heightForWidth(self.__itemWidth, indexPath))
        
        let col = indexPath.row % self.numberOfColumns
        let origin = CGPoint(x: padding.left + self.sectionInset.left + CGFloat(col) * (__itemWidth + spacing.x), y: __lastColHeights[col])
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
        
        let origin = CGPoint(x: padding.left + self.sectionInset.left + CGFloat(targetCol) * (__itemWidth + spacing.x), y: __lastColHeights[targetCol])
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
            let max = __lastColHeights.max() ?? self.padding.top + self.sectionInset.top + spacing.y
            let height = max - spacing.y + self.padding.bottom + self.sectionInset.bottom
            return CGSize(width: width, height: height)
        }
        return .zero
    }
    ///返回UICollectionViewLayoutAttributes 类型的数组，
    ///UICollectionViewLayoutAttributes 对象包含cell或view的布局信息。
    ///子类必须重载该方法，并返回该区域内所有元素的布局信息，包括cell,追加视图和装饰视图。
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.__cellAttributes?.easy.union(self.__headerAttributes, self.__footerAttributes)
    }
    ///返回指定indexPath的item的布局信息。子类必须重载该方法,该方法
    ///只能为cell提供布局信息，不能为补充视图和装饰视图提供。
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        var index: Int = 0
        for i in 0..<indexPath.section {
            index += self.collectionView?.numberOfItems(inSection: i) ?? 0
        }
        index += indexPath.row
        return __cellAttributes?[index]
    }
    ///如果你的布局支持追加视图的话，必须重载该方法，该方法返回的是
    ///追加视图的布局信息，kind这个参数区分段头还是段尾的，在collectionview注册的时候回用到该参数。
    open override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        switch elementKind {
        case UICollectionView.elementKindSectionHeader: return __headerAttributes?[indexPath.section]
        case UICollectionView.elementKindSectionFooter: return __footerAttributes?[indexPath.section]
        default: return nil
        }
    }
    
    /*
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

extension EasyStyleSetting where TargetType: EasyCollectionViewFixedColumnsLayout {
    ///边距
    public static func padding(_ paddind:UIEdgeInsets) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.padding = paddind
        })
    }
    ///Section内边距
    public static func sectionInset(_ sectionInset:UIEdgeInsets) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.sectionInset = sectionInset
        })
    }
    ///间距
    public static func spacing(_ spacing:CGPoint) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.spacing = spacing
        })
    }
    ///列数
    public static func numberOfColumns(_ numberOfColumns:Int) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.numberOfColumns = numberOfColumns
        })
    }
    ///行对齐，默认顶部对齐，不对齐则乱序
    public static func lineAlignment(_ lineAlignment:TargetType.LineAlignment) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.lineAlignment = lineAlignment
        })
    }
    ///高度，可根据宽度获取，不设则默认正方型
    public static func heightForWidth(_  height: @escaping TargetType.HeightForWidth) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.heightForWidth = height
        })
    }
    ///Header高度，可根据宽度获取，不设则默认0
    public static func headerHeightForWidth(_ height:@escaping TargetType.HeightForWidth) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.headerHeightForWidth = height
        })
    }
    ///Footer高度，可根据宽度获取，不设则默认0
    public static func footerHeightForWidth(_ height:@escaping TargetType.HeightForWidth) -> EasyStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.footerHeightForWidth = height
        })
    }
}
