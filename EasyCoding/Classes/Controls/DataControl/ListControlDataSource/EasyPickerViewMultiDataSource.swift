//
//  EasyPickerViewMultiDataSource.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/6.
//
#if EASY_DATA

import UIKit

open class EasyPickerViewMultiDataSourceBase<FirstType: EasyDataListProviderType>: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    ///当前操作的tableView
    open weak var pickerView: UIPickerView? {
        didSet {
            self.pickerView?.dataSource = self
            self.pickerView?.delegate = self
        }
    }
    ///总列数
    open var numberOfComponents: Int {
        return 1
    }
    ///全部数据
    open var datas: [[Any]]?
    
    ///数据源
    open var firstDataProvider: FirstType?
    ///数据源请求前设置参数
    open var prepareForFirstData: ((FirstType) -> Void)?
    ///设置Cell的类型，需返回EasyPickerViewCell
    open var viewForFirstCell: () -> EasyPickerViewCell<FirstType.ModelType> = { EasyPickerViewCell<FirstType.ModelType>() }
    ///选择了第一项
    open var actionForFirstSelect: ((FirstType.ModelType, Int) -> Void)?
    
    required public override init() {
        
    }
    ///获取选中的数据
    open var selectedModels:[Any]? {
        if let datas = self.datas, let picker = self.pickerView {
            var models:[Any] = []
            for i in 0..<datas.count {
                models.append(datas[i][picker.selectedRow(inComponent: i)])
            }
            return models
        }
        return nil
    }
    ///获取选中的数据
    open var selectedFirstModel:FirstType.ModelType? {
        if let datas = self.datas, let picker = self.pickerView, datas.count > 0 {
            return datas[0][picker.selectedRow(inComponent: 0)] as? FirstType.ModelType
        }
        return nil
    }
    ///显示加载中视图
    open var viewForLoading: () -> UIView = { UIActivityIndicatorView.easy(.start()) }
    ///行宽比例，不能比数据源的值小
    open var cellWidthProportions: [CGFloat]?
    ///行高
    open var cellHeight: CGFloat = 32
    
    ///将多个数组合并成一个
    public func merge<Element>(lists: [[Element]]) -> [Element] {
        var result: [Element] = []
        for list in lists {
            result.append(contentsOf: list)
        }
        return result
    }
    ///只允许同时只有一个数据在刷新
    private var _loadingFlag = 0
    public func loadingFlag() -> Int {
        self._loadingFlag += 1
        return self._loadingFlag
    }
    /// 刷新数据，请求数据并刷新显示
    open func reloadData() {
        //显示loading
        self.datas = nil
        self.pickerView?.reloadAllComponents()
        if let provider = self.firstDataProvider {
            self.prepareForFirstData?(provider)
            let flag = self.loadingFlag()
            provider.easyDataWithoutError { [weak self] (data) in
                if let s = self, let provider = s.firstDataProvider, s._loadingFlag == flag {
                    let list = s.merge(lists: provider.lists(for: data))
                    s.datas = [list]
                    s.pickerView?.reloadAllComponents()
                    if let first = list.first {
                        s.loadComponent(model: first, index: 1)
                    }
                }
            }
        }
    }
    open func setDatas(_ datas: [Any], index: Int) {
        if let allDatas = self.datas {
            if allDatas.count <= index {
                if allDatas.count == index {
                    self.datas?.append(datas)
                }
            }else{
                self.datas?[index] = datas
            }
        }else{
            if index == 0 {
                self.datas = [datas]
            }
        }
    }
    
    /// 加载数据完成
    /// - Parameters:
    ///   - datas: 数据
    ///   - index: 列数
    ///   - loadingFlag: 必须在请求数据前获取，在请求结束后传入
    open func loadComponentCompleted(_ datas: [Any], index: Int, loadingFlag: Int) {
        if self._loadingFlag == loadingFlag {
            self.setDatas(datas, index: index)
            self.pickerView?.reloadComponent(index)
            if let first = datas.first {
                self.loadComponent(model: first, index: index + 1)
            }
        }
    }
    ///子类重载
    open func loadComponent(model: Any, index: Int) {
        if index >= self.numberOfComponents {
            return
        }
        if index < self.numberOfComponents {
            ///加载前把数据清除显示loading
            while self.datas?.count ?? 0 > index {
                self.datas?.removeLast()
            }
            for i in index..<self.numberOfComponents {
                self.pickerView?.reloadComponent(i)
            }
        }
    }
    ///子类重载
    open func viewForCell(component: Int, reusing view: UIView?) -> UIView {
        if component == 0 {
            return (view as? EasyPickerViewCell<FirstType.ModelType>) ?? self.viewForFirstCell()
        }
        return UIView()
    }
    ///加载模型数据
    open func loadCell(_ cell: UIView , model: Any, component: Int, row: Int) {
        if component == 0 {
            if let view = cell as? EasyPickerViewCell<FirstType.ModelType>, let m = model as? FirstType.ModelType {
                view.load(model: m, component: component, row: row)
            }
        }
    }
    ///选则了某一项
    open func select(model: Any, component: Int, row: Int) {
        if component == 0, let m = model as? FirstType.ModelType {
            self.actionForFirstSelect?(m, row)
        }
    }
    open func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.numberOfComponents
    }
    
    open func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let datas = self.datas {
            if datas.count > component {
                return datas[component].count
            }
        }
        return 1
    }
    
    open func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        let width = pickerView.bounds.size.width
        let count = self.numberOfComponents
        if let widths = self.cellWidthProportions, count > 1 {
            var all: CGFloat = 0
            for i in 0..<count {
                if i < widths.count {
                    all += widths[i]
                }else{
                    all += 1
                }
            }
            return width / all * (component < widths.count ? widths[component] : 1)
        }else{
            return width / CGFloat(count)
        }
    }
    
    open func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return self.cellHeight
    }
    open func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if let datas = self.datas {
            if datas.count > component {
                let model = datas[component][row]
                let cell = self.viewForCell(component: component, reusing: view)
                self.loadCell(cell, model: model, component: component, row: row)
                return cell
            }
        }
        return self.viewForLoading()
    }
    
    open func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let datas = self.datas {
            if datas.count > component {
                let model = datas[component][row]
                self.select(model: model, component: component, row: row)
                if component < self.numberOfComponents - 1 {
                    self.loadComponent(model: model, index: component + 1)
                }
            }
        }
    }
    
}
///两个数据源
open class EasyPickerViewDataSource2<FirstType: EasyDataListProviderType, SecondType: EasyDataListProviderType>: EasyPickerViewMultiDataSourceBase<FirstType> {
    open override var numberOfComponents: Int {
        return 2
    }
    ///数据源
    open var secondDataProvider: SecondType?
    ///数据源请求前设置参数
    open var prepareForSecondData: ((FirstType.ModelType, SecondType) -> Void)?
    ///设置Cell的类型，需返回EasyPickerViewCell
    open var viewForSecondCell: () -> EasyPickerViewCell<SecondType.ModelType> = { EasyPickerViewCell<SecondType.ModelType>() }
    ///选择了第一项
    open var actionForSecondSelect: ((SecondType.ModelType, Int) -> Void)?
    ///获取选中的数据
    open var selectedSecondModel:SecondType.ModelType? {
        if let datas = self.datas, let picker = self.pickerView, datas.count > 1 {
            return datas[1][picker.selectedRow(inComponent: 1)] as? SecondType.ModelType
        }
        return nil
    }
    ///子类重载
    open override func loadComponent(model: Any, index: Int) {
        super.loadComponent(model: model, index: index)
        if index == 1, let provider = self.secondDataProvider {
            self.prepareForSecondData?(model as! FirstType.ModelType, provider)
            let flag = self.loadingFlag()
            provider.easyDataWithoutError { [weak self] (data) in
                if let s = self, let provider = s.secondDataProvider {
                    let list = s.merge(lists: provider.lists(for: data))
                    s.loadComponentCompleted(list, index: 1, loadingFlag: flag)
                }
            }
        }
    }
    ///子类重载
    open override func viewForCell(component: Int, reusing view: UIView?) -> UIView {
        if component == 1 {
            return (view as? EasyPickerViewCell<SecondType.ModelType>) ?? self.viewForSecondCell()
        }
        return super.viewForCell(component: component, reusing: view)
    }
    ///加载模型数据
    open override func loadCell(_ cell: UIView , model: Any, component: Int, row: Int) {
        super.loadCell(cell, model: model, component: component, row: row)
        if component == 1 {
            if let view = cell as? EasyPickerViewCell<SecondType.ModelType>, let m = model as? SecondType.ModelType {
                view.load(model: m, component: component, row: row)
            }
        }
    }
    ///选则了某一项
    open override func select(model: Any, component: Int, row: Int) {
        super.select(model: model, component: component, row: row)
        if component == 1, let m = model as? SecondType.ModelType {
            self.actionForSecondSelect?(m, row)
        }
    }
}
///三个数据源
open class EasyPickerViewDataSource3<FirstType: EasyDataListProviderType, SecondType: EasyDataListProviderType, ThirdType: EasyDataListProviderType>: EasyPickerViewDataSource2<FirstType, SecondType> {
    open override var numberOfComponents: Int {
        return 3
    }
    ///数据源
    open var thirdDataProvider: ThirdType?
    ///数据源请求前设置参数
    open var prepareForThirdData: ((SecondType.ModelType, ThirdType) -> Void)?
    ///设置Cell的类型，需返回EasyPickerViewCell
    open var viewForThirdCell: () -> EasyPickerViewCell<ThirdType.ModelType> = { EasyPickerViewCell<ThirdType.ModelType>() }
    ///选择了第一项
    open var actionForThirdSelect: ((ThirdType.ModelType, Int) -> Void)?
    ///获取选中的数据
    open var selectedThirdModel:ThirdType.ModelType? {
        if let datas = self.datas, let picker = self.pickerView, datas.count > 2 {
            return datas[2][picker.selectedRow(inComponent: 2)] as? ThirdType.ModelType
        }
        return nil
    }
    ///子类重载
    open override func loadComponent(model: Any, index: Int) {
        super.loadComponent(model: model, index: index)
        if index == 2, let provider = self.thirdDataProvider {
            self.prepareForThirdData?(model as! SecondType.ModelType, provider)
            let flag = self.loadingFlag()
            provider.easyDataWithoutError { [weak self] (data) in
                if let s = self, let provider = s.thirdDataProvider {
                    let list = s.merge(lists: provider.lists(for: data))
                    s.loadComponentCompleted(list, index: 2, loadingFlag: flag)
                }
            }
        }
    }
    ///子类重载
    open override func viewForCell(component: Int, reusing view: UIView?) -> UIView {
        if component == 2 {
            return (view as? EasyPickerViewCell<ThirdType.ModelType>) ?? self.viewForThirdCell()
        }
        return super.viewForCell(component: component, reusing: view)
    }
    ///加载模型数据
    open override func loadCell(_ cell: UIView , model: Any, component: Int, row: Int) {
        super.loadCell(cell, model: model, component: component, row: row)
        if component == 2 {
            if let view = cell as? EasyPickerViewCell<ThirdType.ModelType>, let m = model as? ThirdType.ModelType {
                view.load(model: m, component: component, row: row)
            }
        }
    }
    ///选则了某一项
    open override func select(model: Any, component: Int, row: Int) {
        super.select(model: model, component: component, row: row)
        if component == 2, let m = model as? ThirdType.ModelType {
            self.actionForThirdSelect?(m, row)
        }
    }
}
///四个数据源
open class EasyPickerViewDataSource4<FirstType: EasyDataListProviderType, SecondType: EasyDataListProviderType, ThirdType: EasyDataListProviderType, FourthType: EasyDataListProviderType>: EasyPickerViewDataSource3<FirstType, SecondType, ThirdType> {
    open override var numberOfComponents: Int {
        return 4
    }
    ///数据源
    open var fourthDataProvider: FourthType?
    ///数据源请求前设置参数
    open var prepareForFourthData: ((ThirdType.ModelType, FourthType) -> Void)?
    ///设置Cell的类型，需返回EasyPickerViewCell
    open var viewForFourthCell: () -> EasyPickerViewCell<FourthType.ModelType> = { EasyPickerViewCell<FourthType.ModelType>() }
    ///选择了第一项
    open var actionForFourthSelect: ((FourthType.ModelType, Int) -> Void)?
    ///获取选中的数据
    open var selectedFourthModel: FourthType.ModelType? {
        if let datas = self.datas, let picker = self.pickerView, datas.count > 3 {
            return datas[3][picker.selectedRow(inComponent: 3)] as? FourthType.ModelType
        }
        return nil
    }
    ///子类重载
    open override func loadComponent(model: Any, index: Int) {
        super.loadComponent(model: model, index: index)
        if index == 3, let provider = self.fourthDataProvider {
            self.prepareForFourthData?(model as! ThirdType.ModelType, provider)
            let flag = self.loadingFlag()
            provider.easyDataWithoutError { [weak self] (data) in
                if let s = self, let provider = s.fourthDataProvider {
                    let list = s.merge(lists: provider.lists(for: data))
                    s.loadComponentCompleted(list, index: 3, loadingFlag: flag)
                }
            }
        }
    }
    ///子类重载
    open override func viewForCell(component: Int, reusing view: UIView?) -> UIView {
        if component == 3 {
            return (view as? EasyPickerViewCell<FourthType.ModelType>) ?? self.viewForFourthCell()
        }
        return super.viewForCell(component: component, reusing: view)
    }
    ///加载模型数据
    open override func loadCell(_ cell: UIView , model: Any, component: Int, row: Int) {
        super.loadCell(cell, model: model, component: component, row: row)
        if component == 3 {
            if let view = cell as? EasyPickerViewCell<FourthType.ModelType>, let m = model as? FourthType.ModelType {
                view.load(model: m, component: component, row: row)
            }
        }
    }
    ///选则了某一项
    open override func select(model: Any, component: Int, row: Int) {
        super.select(model: model, component: component, row: row)
        if component == 3, let m = model as? FourthType.ModelType {
            self.actionForFourthSelect?(m, row)
        }
    }
}

extension EasyCoding where Base: UIPickerView {
    ///创建Easy数据源
    public func createDataSource<FirstType: EasyDataListProviderType, SecondType: EasyDataListProviderType>(providers first: FirstType, _ second: SecondType) -> EasyPickerViewDataSource2<FirstType,SecondType> {
        let dataSource = EasyPickerViewDataSource2<FirstType,SecondType>()
        dataSource.firstDataProvider = first
        dataSource.secondDataProvider = second
        dataSource.pickerView = self.base
        return dataSource
    }
    ///创建Easy数据源
    public func createDataSource<FirstType: EasyDataListProviderType, SecondType: EasyDataListProviderType, ThirdType: EasyDataListProviderType>(providers first: FirstType, _ second: SecondType,_ third: ThirdType) -> EasyPickerViewDataSource3<FirstType,SecondType,ThirdType> {
        let dataSource = EasyPickerViewDataSource3<FirstType,SecondType,ThirdType>()
        dataSource.firstDataProvider = first
        dataSource.secondDataProvider = second
        dataSource.thirdDataProvider = third
        dataSource.pickerView = self.base
        return dataSource
    }
    ///创建Easy数据源
    public func createDataSource<FirstType: EasyDataListProviderType, SecondType: EasyDataListProviderType, ThirdType: EasyDataListProviderType, FourthType: EasyDataListProviderType>(providers first: FirstType, _ second: SecondType,_ third: ThirdType,_ fourth: FourthType) -> EasyPickerViewDataSource4<FirstType,SecondType,ThirdType,FourthType> {
        let dataSource = EasyPickerViewDataSource4<FirstType,SecondType,ThirdType,FourthType>()
        dataSource.firstDataProvider = first
        dataSource.secondDataProvider = second
        dataSource.thirdDataProvider = third
        dataSource.fourthDataProvider = fourth
        dataSource.pickerView = self.base
        return dataSource
    }
}

#endif
