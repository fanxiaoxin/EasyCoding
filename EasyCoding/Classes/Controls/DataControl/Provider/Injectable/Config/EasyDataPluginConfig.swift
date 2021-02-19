//
//  EasyDataPluginConfig.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/13.
//

#if EASY_DATA

import UIKit
#if canImport(MJRefresh)
import MJRefresh
#endif

open class EasyDataPluginConfig {
    ///单例，可改变
    public static var shared = EasyDataPluginConfig()
    
    ///空数据视图配置,不能静态，只能手动创建
    public let empty = EasyCustomControlConfig<UIView>(viewBuilder: { EmptyView() }, layouts: [.center])
    ///空数据视图配置
    public let error = EasyCustomControlConfig<ErrorView>(viewBuilder: { ErrorView() }, layouts: [.center])
    ///Loading视图配置
    public let loading = EasyCustomControlConfig<UIView>(viewBuilder: { EasyLoadingView() }, layouts: [.center])
    
    #if canImport(MJRefresh)
    ///默认的下拉刷新
    public var headerBuilder: () -> MJRefreshHeader = { MJRefreshNormalHeader () }
    ///默认的上拉加载更多
    public var footerBuilder: () -> MJRefreshFooter = { MJRefreshBackStateFooter () }
    #endif
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
             let image = UIImage.init(named: "data_empty", in: .init(for: EasyDataPluginConfig.self), compatibleWith: nil)
             self.easy.add(UIImageView.easy(.image(image)), layout: .top, .centerX)
                 .next(.label(.font(EasyControlSetting.Font.normal), .color(EasyControlSetting.Color.light), .text("暂无数据")), layout: .bottomTop(15))
                 .parent(.marginX, .bottom)
         }
     }
    ///默认的错误视图
    open class ErrorView: UIView, EasyDataErrorViewType {
        public var error: Error? {
            didSet {
                self.errorLabel.text = error?.friendlyText
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
            let image = UIImage.init(named: "data_error", in: .init(for: EasyDataPluginConfig.self), compatibleWith: nil)
            self.easy.add(UIImageView.easy(.image(image)), layout: .top, .centerX)
                .next(errorLabel.easy(.font(EasyControlSetting.Font.normal), .color(EasyControlSetting.Color.light), .text("网络异常，请检查网络")), layout: .bottomTop(8), .paddingX)
                .next(.easyButton(.font(EasyControlSetting.Font.normal), .color(EasyControlSetting.Color.main), .text("点击重试"), .event(self, #selector(self.retry)), .edge(insets: .easy(x: 10, y: 8))), layout: .bottomTop(12), .centerX)
                .parent(.bottom)
        }
        @objc func retry() {
            self.retryAction?()
        }
    }
}
extension EasyControlSetting {
    public static var DataPlugin: EasyDataPluginConfig { return EasyDataPluginConfig.shared }
}

#endif
