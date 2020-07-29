//
//  ECViewControllerEvent.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/27.
//

import UIKit

public enum ECViewControllerEvent: ECEventType, Hashable {
    case viewDidLoad(ECEventTiming)
    case willAppear(ECEventTiming)
    case didAppear(ECEventTiming)
    case willDisappear(ECEventTiming)
    case didDisappear(ECEventTiming)
    case willLayoutSubviews(ECEventTiming)
    case didLayoutSubviews(ECEventTiming)
    case dealloc
}
extension ECViewControllerEvent {
    ///默认after
    public static var viewDidLoad: ECViewControllerEvent { return .viewDidLoad(.after)}
    ///默认before
    public static var willAppear: ECViewControllerEvent { return .willAppear(.before)}
    ///默认after
    public static var didAppear: ECViewControllerEvent { return .didAppear(.after)}
    ///默认before
    public static var willDisappear: ECViewControllerEvent { return .willDisappear(.before)}
    ///默认after
    public static var didDisappear: ECViewControllerEvent { return .didDisappear(.after)}
    ///默认before
    public static var willLayoutSubviews: ECViewControllerEvent { return .willLayoutSubviews(.before)}
    ///默认after
    public static var didLayoutSubviews: ECViewControllerEvent { return .didLayoutSubviews(.after)}
}
public class ECViewControllerEventPublisher: ECEventPublisher<ECViewControllerEvent>, ECEmptyInstantiable, EasyExtension {
    required public override init() {
        Self.easy.once {
            UIViewController.easy.swizzle(#selector(UIViewController.viewDidLoad), to: #selector(UIViewController.__ecEventViewDidLoad))
            UIViewController.easy.swizzle(#selector(UIViewController.viewWillAppear(_:)), to: #selector(UIViewController.__ecEventViewWillAppear(_:)))
            UIViewController.easy.swizzle(#selector(UIViewController.viewDidAppear(_:)), to: #selector(UIViewController.__ecEventViewDidAppear(_:)))
            UIViewController.easy.swizzle(#selector(UIViewController.viewWillDisappear(_:)), to: #selector(UIViewController.__ecEventViewWillDisappear(_:)))
            UIViewController.easy.swizzle(#selector(UIViewController.viewDidDisappear(_:)), to: #selector(UIViewController.__ecEventViewDidDisappear(_:)))
            UIViewController.easy.swizzle(#selector(UIViewController.viewWillLayoutSubviews), to: #selector(UIViewController.__ecEventViewWillLayoutSubviews))
            UIViewController.easy.swizzle(#selector(UIViewController.viewDidLayoutSubviews), to: #selector(UIViewController.__ecEventViewDidLayoutSubviews))
        }
    }
    deinit {
        self.send(event: .dealloc)
        __ecStaticViewControllerEventPublisher?.send(event: .dealloc)
    }
}
fileprivate var __ecStaticViewControllerEventPublisher: ECViewControllerEventPublisher? = nil

extension UIViewController {
    @objc func __ecEventViewDidLoad() {
        __ecStaticViewControllerEventPublisher?.send(event: .viewDidLoad(.before), for: self)
        self.easy.event.send(event: .viewDidLoad(.before), for: self)
        self.__ecEventViewDidLoad()
        self.easy.event.send(event: .viewDidLoad(.after), for: self)
        __ecStaticViewControllerEventPublisher?.send(event: .viewDidLoad(.after), for: self)
    }
    @objc func __ecEventViewWillAppear(_ animated: Bool) {
        __ecStaticViewControllerEventPublisher?.send(event: .willAppear(.before), for: (target: self, animated: animated))
        self.easy.event.send(event: .willAppear(.before), for: (target: self, animated: animated))
        self.__ecEventViewWillAppear(animated)
        self.easy.event.send(event: .willAppear(.after), for: (target: self, animated: animated))
        __ecStaticViewControllerEventPublisher?.send(event: .willAppear(.after), for: (target: self, animated: animated))
    }
    @objc func __ecEventViewDidAppear(_ animated: Bool) {
        __ecStaticViewControllerEventPublisher?.send(event: .didAppear(.before), for: (target: self, animated: animated))
        self.easy.event.send(event: .didAppear(.before), for: (target: self, animated: animated))
        self.__ecEventViewDidAppear(animated)
        self.easy.event.send(event: .didAppear(.after), for: (target: self, animated: animated))
        __ecStaticViewControllerEventPublisher?.send(event: .didAppear(.after), for: (target: self, animated: animated))
    }
    @objc func __ecEventViewWillDisappear(_ animated: Bool) {
        __ecStaticViewControllerEventPublisher?.send(event: .willDisappear(.before), for: (target: self, animated: animated))
        self.easy.event.send(event: .willDisappear(.before), for: (target: self, animated: animated))
        self.__ecEventViewWillDisappear(animated)
        self.easy.event.send(event: .willDisappear(.after), for: (target: self, animated: animated))
        __ecStaticViewControllerEventPublisher?.send(event: .willDisappear(.after), for: (target: self, animated: animated))
    }
    @objc func __ecEventViewDidDisappear(_ animated: Bool) {
        __ecStaticViewControllerEventPublisher?.send(event: .didDisappear(.before), for: (target: self, animated: animated))
        self.easy.event.send(event: .didDisappear(.before), for: (target: self, animated: animated))
        self.__ecEventViewDidDisappear(animated)
        self.easy.event.send(event: .didDisappear(.after), for: (target: self, animated: animated))
        __ecStaticViewControllerEventPublisher?.send(event: .didDisappear(.after), for: (target: self, animated: animated))
    }
    @objc func __ecEventViewWillLayoutSubviews() {
        __ecStaticViewControllerEventPublisher?.send(event: .willLayoutSubviews(.before), for: self)
        self.easy.event.send(event: .willLayoutSubviews(.before), for: self)
        self.__ecEventViewWillLayoutSubviews()
        self.easy.event.send(event: .willLayoutSubviews(.after), for: self)
        __ecStaticViewControllerEventPublisher?.send(event: .willLayoutSubviews(.after), for: self)
    }
    @objc func __ecEventViewDidLayoutSubviews() {
        __ecStaticViewControllerEventPublisher?.send(event: .didLayoutSubviews(.before), for: self)
        self.easy.event.send(event: .didLayoutSubviews(.before), for: self)
        self.__ecEventViewDidLayoutSubviews()
        self.easy.event.send(event: .didLayoutSubviews(.after), for: self)
        __ecStaticViewControllerEventPublisher?.send(event: .didLayoutSubviews(.after), for: self)
    }
}
extension EasyCoding where Base: UIViewController{
    ///给UIViewController添加事件
    public var event: ECViewControllerEventPublisher {
        return self.bindAssociatedObject("ec_extension_event_publisher")
    }
    ///给UIViewController添加事件
    public static var event: ECViewControllerEventPublisher {
        return ECViewControllerEventPublisher.easy.createSingleton(getter: { return __ecStaticViewControllerEventPublisher }, setter: { (publisher) in
            __ecStaticViewControllerEventPublisher = publisher
        })
    }
    ///注册事件
    @discardableResult
    public func when<EventParameterType>(_ event: ECViewControllerEvent, identifier: String? = nil, block: @escaping (EventParameterType)->Void) -> Self {
        self.event.when(event, identifier: identifier, block: block)
        return self
    }
    ///注册事件
    @discardableResult
    public static func when<EventParameterType>(_ event: ECViewControllerEvent, identifier: String? = nil, block: @escaping (EventParameterType)->Void) -> Self.Type {
        self.event.when(event, identifier: identifier, block: block)
        return self
    }
}
extension ECEventPublisherType where Self: UIViewController {
    ///注册事件
    @discardableResult
    public func when<EventParameterType>(easy event: ECViewControllerEvent, identifier: String? = nil, block: @escaping (EventParameterType)->Void) -> Self {
        self.easy.event.when(event, identifier: identifier, block: block)
        return self
    }
}
