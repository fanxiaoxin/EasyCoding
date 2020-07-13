//
//  ECDataPluginConfig.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/13.
//

import UIKit
import MJRefresh

open class ECDataPluginConfig {
    ///单例，可改变
    public static var shared = ECDataPluginConfig()
    
    ///空数据视图配置,不能静态，只能手动创建
    public let empty = ECCustomControlConfig<UIView>(viewBuilder: { EmptyView() }, layouts: [.center])
    ///空数据视图配置
    public let error = ECCustomControlConfig<ErrorView>(viewBuilder: { ErrorView() }, layouts: [.center])
    ///Loading视图配置
    public let loading = ECCustomControlConfig<UIView>(viewBuilder: { ECLoadingView() }, layouts: [.center])
    
    ///默认的下拉刷新
    public var headerBuilder: () -> MJRefreshHeader = { MJRefreshNormalHeader () }
    ///默认的上拉加载更多
    public var footerBuilder: () -> MJRefreshFooter = { MJRefreshBackStateFooter () }
    
    ///默认的空视图
    open class EmptyView: UIView {
         public override init(frame: CGRect) {
             super.init(frame: frame)
             self.load()
         }
         public required init?(coder: NSCoder) {
             super.init(coder: coder)
             self.load()
         }
         public func load() {
             let image = UIImage.init(named: "data_empty", in: .easyCoding, compatibleWith: nil)
             self.easy.add(UIImageView.easy(.image(image)), layout: .top, .centerX)
                 .next(.label(.font(ECSetting.Font.normal), .color(ECSetting.Color.light), .text("暂无数据")), layout: .bottomTop(15))
                 .parent(.marginX, .bottom)
         }
     }
    ///默认的错误视图
    open class ErrorView: UIView, ECDataErrorViewType {
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
extension ECSetting {
    public static var DataPlugin: ECDataPluginConfig { return ECDataPluginConfig.shared }
}
