//
//  ECPickerViewMultiDataSource.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/6.
//

import UIKit

class ECPickerViewMultiDataSource<DataProviderType: ECDataListChainProviderType>: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    ///总列数
    open var numberOfComponents: Int = 0
    ///全部数据
    open var datas: [[Any]]?
      ///数据源
    open var dataProvider: DataProviderType? {
        didSet {
            self.numberOfComponents = self.dataProvider?.numberOfDataProviders ?? 0
        }
    }
    ///设置Cell的类型，需返回ECPickerViewCell
    open var viewForCell: () -> UIView = { ECPickerViewCell<DataProviderType.ModelType>() }
    ///行宽比例，不能比数据源的值小
    open var cellWidthProportions: [CGFloat]?
    ///行高
    open var cellHeight: CGFloat = 32
    open var actionForSelect: ((ModelType,Int, Int) -> Void)?
    
    /// 刷新数据，请求数据并刷新显示
    open func reloadData() {
        self.dataProvider?.easyDataWithoutError { [weak self] (data) in
            if let s = self, let provider = s.dataProvider {
                s.sections = provider.sections(for: data)
                s.datas = provider.lists(for: data)
                s.indexTitles = provider.indexTitles(for: data)
                s.refreshControl()
            }
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.numberOfComponents
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.datas?[component].count ?? 0
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
            let cell: ECPickerViewCell<ModelType>
            if let c = view as? ECPickerViewCell<ModelType> {
                cell = c
            }else{
                cell = self.viewForCell()
            }
            cell.load(model: model, component: component, row: row)
            return cell
        }
        return UIView()
    }
    
    open func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let model = self.datas?[component][row] {
            self.actionForSelect?(model, component, row)
        }
    }

}
