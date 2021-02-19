//
//  EasyViewEvent.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/27.
//

import UIKit

public enum EasyViewEvent: EasyEventType, Hashable {
    case layoutSubviews(EasyEventTiming)
    case addSubview
    case removeSubview
    case moveToSuperview(EasyEventTiming)
    case removeFromSuperview(EasyEventTiming)
    case moveToWindow(EasyEventTiming)
    case removeFromWindow(EasyEventTiming)
    case dealloc
}
extension EasyViewEvent {
    ///默认after
    public static var layoutSubviews: EasyViewEvent { return .layoutSubviews(.after)}
}
public class EasyViewEventPublisher: EasyEventPublisher<EasyViewEvent>, EasyEmptyInstantiable, EasyExtension {
    required public override init() {
        Self.easy.once {
            UIView.easy.swizzle(#selector(UIView.layoutSubviews), to: #selector(UIView.__easyEventLayoutSubviews))
            UIView.easy.swizzle(#selector(UIView.didAddSubview(_:)), to: #selector(UIView.__easyEventDidAddSubview(_:)))
            UIView.easy.swizzle(#selector(UIView.willRemoveSubview(_:)), to: #selector(UIView.__easyEventWillRemoveSubview(_:)))
            UIView.easy.swizzle(#selector(UIView.willMove(toSuperview:)), to: #selector(UIView.__easyEventWillMove(toSuperview:)))
            UIView.easy.swizzle(#selector(UIView.didMoveToSuperview), to: #selector(UIView.__easyEventDidMoveToSuperview))
            UIView.easy.swizzle(#selector(UIView.willMove(toSuperview:)), to: #selector(UIView.__easyEventWillMove(toSuperview:)))
            UIView.easy.swizzle(#selector(UIView.didMoveToSuperview), to: #selector(UIView.__easyEventDidMoveToSuperview))
            UIView.easy.swizzle(#selector(UIView.didMoveToSuperview), to: #selector(UIView.__easyEventDidMoveToSuperview))
            UIView.easy.swizzle(#selector(UIView.willMove(toWindow:)), to: #selector(UIView.__easyEventWillMove(toWindow:)))
            UIView.easy.swizzle(#selector(UIView.didMoveToWindow), to: #selector(UIView.__easyEventDidMoveToWindow))
        }
    }
    deinit {
        self.send(event: .dealloc)
        __easyStaticViewEventPublisher?.send(event: .dealloc)
    }
}
fileprivate var __easyStaticViewEventPublisher: EasyViewEventPublisher? = nil

extension UIView {
    @objc func __easyEventLayoutSubviews() {
        __easyStaticViewEventPublisher?.send(event: .layoutSubviews(.before), for: self)
        self.easy.event.send(event: .layoutSubviews(.before), for: self)
        self.__easyEventLayoutSubviews()
        self.easy.event.send(event: .layoutSubviews(.after), for: self)
        __easyStaticViewEventPublisher?.send(event: .layoutSubviews(.after), for: self)
    }
    @objc func __easyEventDidAddSubview(_ subview: UIView) {
        self.__easyEventDidAddSubview(subview)
        self.easy.event.send(event: .addSubview, for: (target: self, subview: subview))
        __easyStaticViewEventPublisher?.send(event: .addSubview, for: (target: self, subview: subview))
    }
    @objc func __easyEventWillRemoveSubview(_ subview: UIView) {
        __easyStaticViewEventPublisher?.send(event: .removeSubview, for: (target: self, subview: subview))
        self.easy.event.send(event: .removeSubview, for: (target: self, subview: subview))
        self.__easyEventWillRemoveSubview(subview)
    }
    @objc func __easyEventWillMove(toSuperview newSuperview: UIView?) {
        if let view = newSuperview {
            __easyStaticViewEventPublisher?.send(event: .moveToSuperview(.before), for: (target: self, superview: view))
            self.easy.event.send(event: .moveToSuperview(.before), for: (target: self, superview: view))
        }else{
            __easyStaticViewEventPublisher?.send(event: .removeFromSuperview(.before), for: self)
            self.easy.event.send(event: .removeFromSuperview(.before), for: self)
        }
        self.__easyEventWillMove(toSuperview: newSuperview)
    }
    @objc func __easyEventDidMoveToSuperview() {
        self.__easyEventDidMoveToSuperview()
        if let view = self.superview {
            __easyStaticViewEventPublisher?.send(event: .moveToSuperview(.after), for: (target: self, superview: view))
            self.easy.event.send(event: .moveToSuperview(.after), for: (target: self, superview: view))
        }else{
            __easyStaticViewEventPublisher?.send(event: .removeFromSuperview(.after), for: self)
            self.easy.event.send(event: .removeFromSuperview(.after), for: self)
        }
    }
    @objc func __easyEventWillMove(toWindow newWindow: UIWindow?) {
        if let view = newWindow {
            __easyStaticViewEventPublisher?.send(event: .moveToWindow(.before), for: (target: self, window: view))
            self.easy.event.send(event: .moveToWindow(.before), for: (target: self, window: view))
        }else{
            __easyStaticViewEventPublisher?.send(event: .removeFromWindow(.before), for: self)
            self.easy.event.send(event: .removeFromWindow(.before), for: self)
        }
        self.__easyEventWillMove(toWindow: newWindow)
    }
    @objc func __easyEventDidMoveToWindow() {
        self.__easyEventDidMoveToWindow()
        if let view = self.superview {
            __easyStaticViewEventPublisher?.send(event: .moveToWindow(.after), for: (target: self, window: view))
            self.easy.event.send(event: .moveToWindow(.after), for: (target: self, window: view))
        }else{
            __easyStaticViewEventPublisher?.send(event: .removeFromWindow(.after), for: self)
            self.easy.event.send(event: .removeFromWindow(.after), for: self)
        }
    }
}
extension EasyCoding where Base: UIView{
    ///给UIViewController添加事件
    public var event: EasyViewEventPublisher {
        return self.bindAssociatedObject("ec_extension_event_publisher")
    }
    ///给UIViewController添加事件
    public static var event: EasyViewEventPublisher {
        return EasyViewEventPublisher.easy.createSingleton(getter: { return __easyStaticViewEventPublisher }, setter: { (publisher) in
            __easyStaticViewEventPublisher = publisher
        })
    }
    ///注册事件
    @discardableResult
    public func when<EventParameterType>(_ event: EasyViewEvent, identifier: String? = nil, block: @escaping (EventParameterType)->Void) -> Self {
        self.event.when(event, identifier: identifier, block: block)
        return self
    }
    ///注册事件
    @discardableResult
    public static func when<EventParameterType>(_ event: EasyViewEvent, identifier: String? = nil, block: @escaping (EventParameterType)->Void) -> Self.Type {
        self.event.when(event, identifier: identifier, block: block)
        return self
    }
}

extension EasyEventPublisherType where Self: UIView {
    ///注册事件
    @discardableResult
    public func when<EventParameterType>(easy event: EasyViewEvent, identifier: String? = nil, block: @escaping (EventParameterType)->Void) -> Self {
        self.easy.event.when(event, identifier: identifier, block: block)
        return self
    }
}
