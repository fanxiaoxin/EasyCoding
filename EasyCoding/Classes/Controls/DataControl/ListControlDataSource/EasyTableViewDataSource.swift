//
//  EasyTableViewDataSource.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/6.
//
#if EASY_DATA

import UIKit

open class EasyTableViewCell<ModelType>: UITableViewCell {
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.load()
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.load()
    }
    ///初始化方法
    open func load() { }
    ///EasyTableViewDataSource第一次加载，手动注册不会调用该方法
    open func awakeFromDataSource() { }
    ///加载模型数据
    open func load(model: ModelType, indexPath: IndexPath) {
        //默认设置Text值
        self.textLabel?.text = EasyText(model)
    }
}
open class EasyTableViewSectionHeaderFooterView<SectionType>: UITableViewHeaderFooterView {
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.load()
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.load()
    }
    ///初始化方法
    open func load() { }
    ///EasyTableViewDataSource第一次加载
    open func awakeFromDataSource() { }
    ///加载模型数据
    open func load(model: SectionType, section: Int) { }
}

///可直接赋予UITableView的dataSource属性，或者手动调用需要的方法
///可直接赋予UITableView的delegate属性，或者手动调用需要的方法
open class EasyTableViewDataSource<DataProviderType: EasyDataListProviderType>: EasyListControlDataSource<DataProviderType>, UITableViewDataSource, UITableViewDelegate {
    ///当前操作的tableView
    open weak var tableView: UITableView? {
        didSet {
            self.tableView?.dataSource = self
            self.tableView?.delegate = self
        }
    }
    ///设置Cell的类型，以后IOS13可以改为用some 协议的方式
    open var typeForCell: (ModelType, IndexPath) -> EasyTableViewCell<ModelType>.Type = { _, _ in EasyTableViewCell<ModelType>.self }
    ///设置Cell的标识，用于已添加Cell到TableView的缓存
    open var identifierForCell: ((ModelType, IndexPath) -> String)?
    ///设置SectionHeader的View
    open var typeForSectionHeader: ((SectionType, Int) -> EasyTableViewSectionHeaderFooterView<SectionType>.Type)?
    ///设置SectionFooter的View
    open var typeForSectionFooter: ((SectionType, Int) -> EasyTableViewSectionHeaderFooterView<SectionType>.Type)?
    ///设置点击事件
    open var actionForSelect: ((UITableView, ModelType, IndexPath) -> Void)?
    ///设置编辑事件
    open var actionForEdit: ((UITableView, UITableViewCell.EditingStyle, ModelType, IndexPath) -> Void)?
    ///设置移动事件
    open var actionForMove: ((UITableView, IndexPath, IndexPath) -> Void)?
    ///获取选中的数据
    open var selectedModels:[ModelType]? {
        if let datas = self.datas, let table = self.tableView, let indexPaths = table.indexPathsForSelectedRows {
            var models:[ModelType] = []
            for indexPath in indexPaths {
                models.append(datas[indexPath.section][indexPath.row])
            }
            return models
        }
        return nil
    }
    
    open override func refreshControl() {
        if self.sections == nil && self.tableView?.delegate === self {
            if self.typeForSectionHeader == nil {
                self.tableView?.sectionHeaderHeight = 0
            }
            if self.typeForSectionFooter == nil {
                self.tableView?.sectionFooterHeight = 0
            }
        }
        self.tableView?.reloadData()
    }
    
    // MARK: Section
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return self.datas?.count ?? 0
    }
    open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        if let titles = self.sections as? [String] {
            return titles[section]
        }
        return nil
    }
    open func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return nil
    }
    
    // MARK: Cell
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datas?[section].count ?? 0
    }
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let model = self.datas?[indexPath.section][indexPath.row] {
            let cell: EasyTableViewCell<ModelType>
            if let identifier = self.identifierForCell?(model, indexPath), let c = tableView.dequeueReusableCell(withIdentifier: identifier)  {
                cell = c as! EasyTableViewCell<ModelType>
            }else{
                let cellType = self.typeForCell(model, indexPath)
                let identifier = NSStringFromClass(cellType)
                if let c = tableView.dequeueReusableCell(withIdentifier:identifier) {
                    cell = c as! EasyTableViewCell<ModelType>
                }else{
                    tableView.register(cellType, forCellReuseIdentifier: identifier)
                    cell = tableView.dequeueReusableCell(withIdentifier:identifier) as! EasyTableViewCell<ModelType>
                    cell.awakeFromDataSource()
                }
            }
            cell.load(model: model, indexPath: indexPath)
            
            return cell
        }
        fatalError("没有数据")
    }
    
    // MARK: Indexs
    
    open func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.indexTitles
    }
    open func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return self.dataProvider?.indexPathForIndexTitle(title, at: index).section ?? 0
    }
    
    // MARK: Edit & Move
    
    open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return self.actionForEdit != nil
    }
    open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if let model = self.datas?[indexPath.section][indexPath.row] {
            self.actionForEdit?(tableView, editingStyle, model, indexPath)
        }
    }
    open func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return self.actionForMove != nil
    }
    open func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        self.actionForMove?(tableView, sourceIndexPath, destinationIndexPath)
    }
    
    // MARK: Delegate - Section Header & Footer
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.tableView(tableView, viewForHeaderFooterInSection: section, builder: self.typeForSectionHeader)
    }

    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return self.tableView(tableView, viewForHeaderFooterInSection: section, builder: self.typeForSectionFooter)
    }
    open func tableView(_ tableView: UITableView, viewForHeaderFooterInSection section: Int, builder: ((SectionType, Int) -> EasyTableViewSectionHeaderFooterView<SectionType>.Type)?) -> UIView? {
        if let model = self.sections?[section] {
            if let viewType = builder?(model, section) {
                let identifier = NSStringFromClass(viewType)
                let view: EasyTableViewSectionHeaderFooterView<SectionType>
                if let v = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) {
                    view = v as! EasyTableViewSectionHeaderFooterView<SectionType>
                }else{
                    tableView.register(viewType, forHeaderFooterViewReuseIdentifier: identifier)
                    view = tableView.dequeueReusableHeaderFooterView(withIdentifier:identifier) as! EasyTableViewSectionHeaderFooterView<SectionType>
                    view.awakeFromDataSource()
                }
                
                view.load(model: model, section: section)
                
                return view
            }
        }
        return nil
    }
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = self.datas?[indexPath.section][indexPath.row] {
            self.actionForSelect?(tableView, model, indexPath)
        }
    }
}
extension EasyCoding where Base: UITableView {
    ///创建Easy数据源
    public func createDataSource<DataProviderType: EasyDataProviderType>(provider: DataProviderType) -> EasyTableViewDataSource<DataProviderType> {
        let dataSource = EasyTableViewDataSource<DataProviderType>()
        dataSource.dataProvider = provider
        dataSource.tableView = self.base
        return dataSource
    }
}

#endif
