//
//  EasyViewControllerEvent.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/27.
//

import UIKit

public enum EasyViewControllerEvent: EasyEventType, Hashable {
    case viewDidLoad(EasyEventTiming)
    case willAppear(EasyEventTiming)
    case didAppear(EasyEventTiming)
    case willDisappear(EasyEventTiming)
    case didDisappear(EasyEventTiming)
    case willLayoutSubviews(EasyEventTiming)
    case didLayoutSubviews(EasyEventTiming)
    case dealloc
}
extension EasyViewControllerEvent {
    ///默认after
    public static var viewDidLoad: EasyViewControllerEvent { return .viewDidLoad(.after)}
    ///默认before
    public static var willAppear: EasyViewControllerEvent { return .willAppear(.before)}
    ///默认after
    public static var didAppear: EasyViewControllerEvent { return .didAppear(.after)}
    ///默认before
    public static var willDisappear: EasyViewControllerEvent { return .willDisappear(.before)}
    ///默认after
    public static var didDisappear: EasyViewControllerEvent { return .didDisappear(.after)}
    ///默认before
    public static var willLayoutSubviews: EasyViewControllerEvent { return .willLayoutSubviews(.before)}
    ///默认after
    public static var didLayoutSubviews: EasyViewControllerEvent { return .didLayoutSubviews(.after)}
}
public class EasyViewControllerEventPublisher: EasyEventPublisher<EasyViewControllerEvent>, EasyEmptyInstantiable, EasyExtension {
    required public override init() {
        Self.easy.once {
            UIViewController.easy.swizzle(#selector(UIViewController.viewDidLoad), to: #selector(UIViewController.__easyEventViewDidLoad))
            UIViewController.easy.swizzle(#selector(UIViewController.viewWillAppear(_:)), to: #selector(UIViewController.__easyEventViewWillAppear(_:)))
            UIViewController.easy.swizzle(#selector(UIViewController.viewDidAppear(_:)), to: #selector(UIViewController.__easyEventViewDidAppear(_:)))
            UIViewController.easy.swizzle(#selector(UIViewController.viewWillDisappear(_:)), to: #selector(UIViewController.__easyEventViewWillDisappear(_:)))
            UIViewController.easy.swizzle(#selector(UIViewController.viewDidDisappear(_:)), to: #selector(UIViewController.__easyEventViewDidDisappear(_:)))
            UIViewController.easy.swizzle(#selector(UIViewController.viewWillLayoutSubviews), to: #selector(UIViewController.__easyEventViewWillLayoutSubviews))
            UIViewController.easy.swizzle(#selector(UIViewController.viewDidLayoutSubviews), to: #selector(UIViewController.__easyEventViewDidLayoutSubviews))
        }
    }
    deinit {
        self.send(event: .dealloc)
        __easyStaticViewControllerEventPublisher?.send(event: .dealloc)
    }
}
fileprivate var __easyStaticViewControllerEventPublisher: EasyViewControllerEventPublisher? = nil

extension UIViewController {
    @objc func __easyEventViewDidLoad() {
        __easyStaticViewControllerEventPublisher?.send(event: .viewDidLoad(.before), for: self)
        self.easy.event.send(event: .viewDidLoad(.before), for: self)
        self.__easyEventViewDidLoad()
        self.easy.event.send(event: .viewDidLoad(.after), for: self)
        __easyStaticViewControllerEventPublisher?.send(event: .viewDidLoad(.after), for: self)
    }
    @objc func __easyEventViewWillAppear(_ animated: Bool) {
        __easyStaticViewControllerEventPublisher?.send(event: .willAppear(.before), for: (target: self, animated: animated))
        self.easy.event.send(event: .willAppear(.before), for: (target: self, animated: animated))
        self.__easyEventViewWillAppear(animated)
        self.easy.event.send(event: .willAppear(.after), for: (target: self, animated: animated))
        __easyStaticViewControllerEventPublisher?.send(event: .willAppear(.after), for: (target: self, animated: animated))
    }
    @objc func __easyEventViewDidAppear(_ animated: Bool) {
        __easyStaticViewControllerEventPublisher?.send(event: .didAppear(.before), for: (target: self, animated: animated))
        self.easy.event.send(event: .didAppear(.before), for: (target: self, animated: animated))
        self.__easyEventViewDidAppear(animated)
        self.easy.event.send(event: .didAppear(.after), for: (target: self, animated: animated))
        __easyStaticViewControllerEventPublisher?.send(event: .didAppear(.after), for: (target: self, animated: animated))
    }
    @objc func __easyEventViewWillDisappear(_ animated: Bool) {
        __easyStaticViewControllerEventPublisher?.send(event: .willDisappear(.before), for: (target: self, animated: animated))
        self.easy.event.send(event: .willDisappear(.before), for: (target: self, animated: animated))
        self.__easyEventViewWillDisappear(animated)
        self.easy.event.send(event: .willDisappear(.after), for: (target: self, animated: animated))
        __easyStaticViewControllerEventPublisher?.send(event: .willDisappear(.after), for: (target: self, animated: animated))
    }
    @objc func __easyEventViewDidDisappear(_ animated: Bool) {
        __easyStaticViewControllerEventPublisher?.send(event: .didDisappear(.before), for: (target: self, animated: animated))
        self.easy.event.send(event: .didDisappear(.before), for: (target: self, animated: animated))
        self.__easyEventViewDidDisappear(animated)
        self.easy.event.send(event: .didDisappear(.after), for: (target: self, animated: animated))
        __easyStaticViewControllerEventPublisher?.send(event: .didDisappear(.after), for: (target: self, animated: animated))
    }
    @objc func __easyEventViewWillLayoutSubviews() {
        __easyStaticViewControllerEventPublisher?.send(event: .willLayoutSubviews(.before), for: self)
        self.easy.event.send(event: .willLayoutSubviews(.before), for: self)
        self.__easyEventViewWillLayoutSubviews()
        self.easy.event.send(event: .willLayoutSubviews(.after), for: self)
        __easyStaticViewControllerEventPublisher?.send(event: .willLayoutSubviews(.after), for: self)
    }
    @objc func __easyEventViewDidLayoutSubviews() {
        __easyStaticViewControllerEventPublisher?.send(event: .didLayoutSubviews(.before), for: self)
        self.easy.event.send(event: .didLayoutSubviews(.before), for: self)
        self.__easyEventViewDidLayoutSubviews()
        self.easy.event.send(event: .didLayoutSubviews(.after), for: self)
        __easyStaticViewControllerEventPublisher?.send(event: .didLayoutSubviews(.after), for: self)
    }
}
extension EasyCoding where Base: UIViewController{
    ///给UIViewController添加事件
    public var event: EasyViewControllerEventPublisher {
        return self.bindAssociatedObject("ec_extension_event_publisher")
    }
    ///给UIViewController添加事件
    public static var event: EasyViewControllerEventPublisher {
        return EasyViewControllerEventPublisher.easy.createSingleton(getter: { return __easyStaticViewControllerEventPublisher }, setter: { (publisher) in
            __easyStaticViewControllerEventPublisher = publisher
        })
    }
    ///注册事件
    @discardableResult
    public func when<EventParameterType>(_ event: EasyViewControllerEvent, identifier: String? = nil, block: @escaping (EventParameterType)->Void) -> Self {
        self.event.when(event, identifier: identifier, block: block)
        return self
    }
    ///注册事件
    @discardableResult
    public static func when<EventParameterType>(_ event: EasyViewControllerEvent, identifier: String? = nil, block: @escaping (EventParameterType)->Void) -> Self.Type {
        self.event.when(event, identifier: identifier, block: block)
        return self
    }
}
extension EasyEventPublisherType where Self: UIViewController {
    ///注册事件
    @discardableResult
    public func when<EventParameterType>(easy event: EasyViewControllerEvent, identifier: String? = nil, block: @escaping (EventParameterType)->Void) -> Self {
        self.easy.event.when(event, identifier: identifier, block: block)
        return self
    }
}
