//
//  ECDataErrorDecorator.swift
//  Alamofire
//
//  Created by JY_NEW on 2020/6/30.
//

import UIKit

public protocol ECDataErrorViewType: UIView {
    ///设置最后一次请求异常信息
    var error: Error? { get set }
    ///重试操作
    var retryAction: (() -> Void)? { get set }
}

open class ECDataErrorPlugin<DataType>: ECDataErrorPluginBase<DataType> {
    ///要加载到的页面，若为空则加载到keywindow
    open weak var targetView: UIView?
    ///加载页
    open lazy var errorView: ECDataErrorViewType = {
        return ErrorView()
    }()
    ///配置，可修改布局及加载隐藏动画
    public let config = ECCustomControlConfig<UIView>(layouts: [.center])
    
    open override func load() {
        self.errorView.error = self.error
        self.errorView.retryAction = { [weak self] in
            self?.reloadData()
        }
        if let targetView = self.targetView {
            self.config.show(self.errorView, at: targetView)
        }
    }
    
    open override func unload() {
        self.config.dismiss(self.errorView)
    }
    public class ErrorView: UIView, ECDataErrorViewType {
           public var error: Error? {
               didSet {
                   self.errorLabel.text = error?.localizedDescription
               }
           }
           
           public var retryAction: (() -> Void)?
           
           let errorLabel = UILabel()
           
           public override init(frame: CGRect) {
               super.init(frame: frame)
               self.load()
           }
           public required init?(coder: NSCoder) {
               super.init(coder: coder)
               self.load()
           }
           public func load() {
               let image = UIImage.init(named: "data_error", in: .easyCoding, compatibleWith: nil)
               self.easy.add(UIImageView.easy(.image(image)), layout: .top, .centerX)
                   .next(errorLabel.easy(.font(ECSetting.Font.normal), .color(ECSetting.Color.light), .text("网络异常，请检查网络")), layout: .bottomTop(8), .paddingX)
                   .next(.easyButton(.font(ECSetting.Font.normal), .color(ECSetting.Color.main), .text("点击重试"), .event(self, #selector(self.retry)), .edge(insets: .easy(x: 10, y: 8))), layout: .bottomTop(12), .centerX)
                   .parent(.bottom)
           }
           @objc func retry() {
               self.retryAction?()
           }
       }
}
