//
//  ViewController.swift
//  EasyCoding
//
//  Created by fanxiaoxin_1987@126.com on 06/02/2020.
//  Copyright (c) 2020 fanxiaoxin_1987@126.com. All rights reserved.
//

import UIKit
import EasyCoding
//import SnapKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //        self.view.easy.add(.build({ (view) in
        //            view.add(UILabel.easy(.center), layout: .top, .left(3))
        //        }), layout: .right(30))
        
        let views = [UIView.easy(.bg(.red)),
                     UIView.easy(.bg(.blue), .tap(self, #selector(self.test))),
                     UIView.easy(.bg(.green)),
                     UILabel.easy(.lines(), .attr("我是一段富文本，要问我有多\("富234234234", .boldFont(size: 20), .color(.red)),我也不知道", .color(.blue), .font(size: 14)))]
        views[0].easy.layout(.priority(.height(10), .low))
        views[1].easy.layout(.priority(.height(20), .low))
        views[2].easy.layout(.priority(.height(30), .low))
        views[3].easy.layout(.priority(.height(30), .low))
        
        let stack = UIStackView()
        self.view.easy.style(.bg(.init(white: 0.9, alpha: 1))).add(stack.easy(.views(views),
                                                                              .axis(.vertical), .alignment(.fill), .distribution(.fillProportionally)), layout: .margin(50))
        
        
        //        let view = UIView.easy(.bg(.yellow), .height(5))
        //            stack.addSubview(view)
        //        view.snp.makeConstraints { (make) in
        //            make.left.right.equalTo(stack)
        //            make.centerY.equalTo(views[0].snp.bottom)
        //            make.centerY.equalTo(views[1].snp.top)
        //        }
    }
    @objc func test() {
        //        ECAlertConfig.default.message.addStyle(.boldFont(size: 20))
        //        ECAlertConfig.default.input.addStyle(.bg(.green))
        //        ECAlertConfig.default.input.layout(.margin(180, 0, 150, 0))
        ECMessageBox.confirm(title: "看这个标题", attr: "try metry \("trye3 ry metrry metr", .color(.red), .boldFont(size: 24)) metry metry metry me") { [weak self] in
            //自定义视图
            //自定义列表，可多组，可异步
            //日期
        }
    }
    
}



class ECDataLoadingProvider<DataProviderType: ECDataProviderType>: ECDataLoadingDecoratorType {
    
    var targetView: UIView?

    var loadingView: ECDataLoadingViewType {
        return UIView() as! ECDataLoadingViewType
    }
    var dataProvider: DataProviderType?
}
//func xx() {
//    let a = ECDataLoadingProvider<[String]>()
//    a.easyData { (data) in
//        let str = data
//    }
//}
 /*
///可见化数据源
public protocol ECVisualizedDataProvider: ECDataProviderType {
    associatedtype DataProviderType: ECDataProviderType
    ///包装的数据源请求器
    var dataProvider: DataProviderType? { get }
    ///最后一次加载的响应，需要存起来，在重试的时候使用
    var lastCompletion: ((DataProviderType.DataType?, Error?) -> Void)? { get set }
    
    ///数据加载中页面，如loading，常用
    var dataLoadingView: ECDataLoadingViewType? { get }
    ///数据请求出错页面，仅在出错时调用，建议懒加载或每次调用时创建
    var dataErrorView: ECDataErrorViewType? { get }
    ///数据为空时显示的页面，仅在数据为空时调用，建议懒加载或每次调用时创建
    var dataEmptyView: ECDataEmptyViewType? { get }
    
    ///要加载请求中页面的View
    var dataLoadingParentView: UIView? { get set }
    ///要加载请求出错页面的View
    var dataErrorParentView: UIView? { get set }
    ///要加载空数据页面的View
    var dataEmptyParentView: UIView? { get set }
    
    ///加载请求中页面，在该方法中将self.dataLoadingView加载到self.dataLoadingParentView
    func loadLoadingView()
    ///加载请求出错页面，在该方法中将self.dataErrorView加载到self.dataErrorParentView
    func loadErrorView()
    ///加载空数据页面，在该方法中将self.dataEmptyView加载到self.dataEmptyParentView
    func loadEmptyView()
    
    ///重试加载数据
    func retry()
}
extension ECVisualizedDataProvider where Self: AnyObject {
//    public typealias DataType = DataProviderType.DataType
    ///加载数据时直接调用内部的数据源
    public func easyData(completion: @escaping (DataProviderType.DataType?, Error?) -> Void) {
        self.dataProvider?.easyData { [weak self] (data, error) in
            completion(data, error)
            self?.lastCompletion = completion
        }
    }
    ///要显示目标的视图
    public var targetView: UIView? {
        get {
            return self.dataErrorParentView ?? self.dataEmptyParentView ?? self.dataLoadingParentView
        }
        set {
//            self.dataErrorParentView = newValue
//            self.dataEmptyParentView = newValue
//            self.dataLoadingParentView = newValue
        }
    }
    ///加载请求中页面，默认加载到父视图中间
    public func loadLoadingView() {
        if let empty = self.dataLoadingView, let parent = self.dataLoadingParentView {
            parent.easy.add(empty, layout: .center)
        }
    }
    ///加载请求出错页面，默认填充父视图
    public func loadErrorView() {
        if let empty = self.dataErrorView, let parent = self.dataErrorParentView {
            parent.easy.add(empty, layout: .margin)
        }
    }
    ///加载空数据页面，默认填充父视图
    public func loadEmptyView() {
        if let empty = self.dataEmptyView, let parent = self.dataEmptyParentView {
            parent.easy.add(empty, layout: .margin)
        }
    }
    
    ///重试加载数据
    public func retry() {
        if let last = self.lastCompletion {
            self.easyData(completion: last)
        }
    }
}
class AAProvider<DataProviderType: ECDataProviderType>: ECVisualizedDataProvider {
    
    var lastCompletion: ((DataType?, Error?) -> Void)?
    
    var dataLoadingView: ECDataLoadingViewType?
    
    var dataErrorView: ECDataErrorViewType?
    
    var dataEmptyView: ECDataEmptyViewType?
    
    var dataLoadingParentView: UIView?
    
    var dataErrorParentView: UIView?
    
    var dataEmptyParentView: UIView?
    
    
    var dataProvider: DataProviderType?
    
}


///可请求异步数据的类型
public protocol ECAyncDataRequestable {
    associatedtype DataProviderType: ECDataProviderType
    ///数据源请求器
    var dataProvider: DataProviderType { get }
    
    ///数据加载中页面，如loading，常用
    var dataLoadingView: ECDataLoadingViewType { get }
    ///数据请求出错页面，仅在出错时调用，建议懒加载或每次调用时创建
    var dataErrorView: ECDataErrorViewType { get }
    ///数据为空时显示的页面，仅在数据为空时调用，建议懒加载或每次调用时创建
    var dataEmptyView: ECDataEmptyViewType { get }
    
    ///数据加载的配置
    var dataLoadingConfig: ECCustomControlConfig<UIView> { get }
    ///数据请求出错的配置
    var dataErrorConfig: ECCustomControlConfig<UIView> { get }
    ///数据为空时的配置
    var dataEmptyConfig: ECCustomControlConfig<UIView> { get }
    
    ///要加载请求出错或空数据页面的View
    var dataLoadingParentView: UIView { get }
    ///要加载请求出错或空数据页面的View
    var dataErrorParentView: UIView { get }
    ///要加载请求出错或空数据页面的View
    var dataEmptyParentView: UIView { get }
    
    ///重新加载数据
    func reloadData()
}
extension ECAyncDataRequestable {
    ///重新加载数据
    public func reloadData() {
        self.dataErrorView.removeFromSuperview()
        self.dataProvider.easyData { (data, error) in
            if let err = error {
                let errorView = self.dataErrorView
                errorView.error = err
                errorView.retryAction = self.reloadData
//                self.load(dataErrorView: errorView)
            }else{
                
            }
        }
    }
}
extension ECAyncDataRequestable where Self: UIView {
    //默认为自身
    var incorrectDataParentView: UIView { return self }
}
extension ECAyncDataRequestable where Self: UIViewController {
    //默认为self.view
    var incorrectDataParentView: UIView { return self.view }
}

*/
class T4 {
    @ECProperty.Clamping(min: 1, max: 5)
    var test: Int = 4
    func callAsFunction(_ p: String?) -> String {
        return p ?? "FUCK"
    }
    func callAsFunction(_ p: String?, d: String) -> String {
        return p ?? "FUCK"
    }
    static func callAsFunction(_ p: Int) -> Int {
        return p
    }
}
///Swift5.1: Some 泛型
///Swift5.1: @propertyWrapper
///Swift5.1: @_functionBuilder
///Swift5.2: callAsFunction 把类当方法一样调用
