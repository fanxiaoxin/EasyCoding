//
//  EasyPickerViewDataSource.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/6.
//
#if EASY_DATA

import UIKit

open class EasyPickerViewCell<ModelType>: UIView {
    public let textLabel = UILabel()
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.load()
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.load()
    }
    ///初始化方法
    open func load() {
        if ModelType.self == String.self {
            self.easy.add(textLabel.easy(.font(EasyControlSetting.Font.normal), .color(EasyControlSetting.Color.text), .center), layout: .margin)
        }
    }
    ///加载模型数据
    open func load(model: ModelType, component: Int, row: Int) {
        if let text = model as? String {
            self.textLabel.text = text
        }
    }
}
open class EasyPickerViewDataSource<DataProviderType: EasyDataListProviderType>: EasyListControlDataSource<DataProviderType>, UIPickerViewDataSource, UIPickerViewDelegate {
    ///当前操作的tableView
    open weak var pickerView: UIPickerView? {
        didSet {
            self.pickerView?.dataSource = self
            self.pickerView?.delegate = self
        }
    }
    ///设置Cell的类型
    open var viewForCell: () -> EasyPickerViewCell<ModelType> = { EasyPickerViewCell<ModelType>() }
    ///显示加载中视图
    open var viewForLoading: (() -> UIView)? = { UIActivityIndicatorView.easy(.start()) }
    ///行宽比例，不能比数据源的值小
    open var cellWidthProportions: [CGFloat]?
    ///行高
    open var cellHeight: CGFloat = 32
    open var actionForSelect: ((ModelType,Int, Int) -> Void)?
    
    ///获取选中的数据
    open var selectedModels:[ModelType]? {
        if let datas = self.datas, let picker = self.pickerView {
            var models:[ModelType] = []
            for i in 0..<datas.count {
                models.append(datas[i][picker.selectedRow(inComponent: i)])
            }
            return models
        }
        return nil
    }
    open override func refreshControl() {
        self.pickerView?.reloadAllComponents()
    }
    
    open func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.datas?.count ?? (self.viewForLoading == nil ? 0 : 1)
    }
    
    open func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.datas?[component].count ?? (self.viewForLoading == nil ? 0 : 1)
    }
    
    open func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        let width = pickerView.bounds.size.width
        let count = self.datas?.count ?? 1
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
        if let model = self.datas?[component][row] {
            let cell: EasyPickerViewCell<ModelType>
            if let c = view as? EasyPickerViewCell<ModelType> {
                cell = c
            }else{
                cell = self.viewForCell()
            }
            cell.load(model: model, component: component, row: row)
            return cell
        }
        return self.viewForLoading?() ?? UIView()
    }
    
    open func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let model = self.datas?[component][row] {
            self.actionForSelect?(model, component, row)
        }
    }
}
extension EasyPickerViewDataSource where ModelType: Equatable {
    ///设置选中值，
    public func setSelectedModels(_ models: [ModelType]) {
        self.whenDataLoaded.add { [weak self] in
            if let s = self, let datas = s.datas {
                for i in 0..<datas.count {
                    if models.count > i,let idx = datas[i].firstIndex(of: models[i]) {
                        s.pickerView?.selectRow(idx, inComponent: i, animated: true)
                    }
                }
            }
        }
    }
}

extension EasyCoding where Base: UIPickerView {
    ///创建Easy数据源
    public func createDataSource<DataProviderType: EasyDataProviderType>(provider: DataProviderType) -> EasyPickerViewDataSource<DataProviderType> {
        let dataSource = EasyPickerViewDataSource<DataProviderType>()
        dataSource.dataProvider = provider
        dataSource.pickerView = self.base
        return dataSource
    }
}

#endif
