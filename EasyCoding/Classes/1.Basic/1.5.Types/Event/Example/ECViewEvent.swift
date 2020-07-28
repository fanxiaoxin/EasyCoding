//
//  ECViewEvent.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/27.
//

import UIKit

public enum ECViewEvent: ECEventType, Hashable {
    case layoutSubviews(ECEventTiming)
    case addSubview
    case removeSubview
    case moveToSuperview(ECEventTiming)
    case removeFromSuperview(ECEventTiming)
    case moveToWindow(ECEventTiming)
    case removeFromWindow(ECEventTiming)
    case dealloc
}
extension ECViewEvent {
    ///默认after
    public static var layoutSubviews: ECViewEvent { return .layoutSubviews(.after)}
}
public class ECViewEventPublisher: ECEventPublisher<ECViewEvent>, ECEmptyInstantiable, EasyExtension {
    required public override init() {
        Self.easy.once {
            UIView.easy.swizzle(#selector(UIView.layoutSubviews), to: #selector(UIView.__ecEventLayoutSubviews))
            UIView.easy.swizzle(#selector(UIView.didAddSubview(_:)), to: #selector(UIView.__ecEventDidAddSubview(_:)))
            UIView.easy.swizzle(#selector(UIView.willRemoveSubview(_:)), to: #selector(UIView.__ecEventWillRemoveSubview(_:)))
            UIView.easy.swizzle(#selector(UIView.willMove(toSuperview:)), to: #selector(UIView.__ecEventWillMove(toSuperview:)))
            UIView.easy.swizzle(#selector(UIView.didMoveToSuperview), to: #selector(UIView.__ecEventDidMoveToSuperview))
            UIView.easy.swizzle(#selector(UIView.willMove(toSuperview:)), to: #selector(UIView.__ecEventWillMove(toSuperview:)))
            UIView.easy.swizzle(#selector(UIView.didMoveToSuperview), to: #selector(UIView.__ecEventDidMoveToSuperview))
            UIView.easy.swizzle(#selector(UIView.didMoveToSuperview), to: #selector(UIView.__ecEventDidMoveToSuperview))
            UIView.easy.swizzle(#selector(UIView.willMove(toWindow:)), to: #selector(UIView.__ecEventWillMove(toWindow:)))
            UIView.easy.swizzle(#selector(UIView.didMoveToWindow), to: #selector(UIView.__ecEventDidMoveToWindow))
        }
    }
    deinit {
        self.send(event: .dealloc)
        __ecStaticViewEventPublisher?.send(event: .dealloc)
    }
}
fileprivate var __ecStaticViewEventPublisher: ECViewEventPublisher? = nil

extension UIView {
    @objc func __ecEventLayoutSubviews() {
        __ecStaticViewEventPublisher?.send(event: .layoutSubviews(.before))
        self.easy.event.send(event: .layoutSubviews(.before))
        self.__ecEventLayoutSubviews()
        self.easy.event.send(event: .layoutSubviews(.after))
        __ecStaticViewEventPublisher?.send(event: .layoutSubviews(.after))
    }
    @objc func __ecEventDidAddSubview(_ subview: UIView) {
        self.__ecEventDidAddSubview(subview)
        self.easy.event.send(event: .addSubview, for: subview)
        __ecStaticViewEventPublisher?.send(event: .addSubview, for: subview)
    }
    @objc func __ecEventWillRemoveSubview(_ subview: UIView) {
        __ecStaticViewEventPublisher?.send(event: .removeSubview, for: subview)
        self.easy.event.send(event: .removeSubview, for: subview)
        self.__ecEventWillRemoveSubview(subview)
    }
    @objc func __ecEventWillMove(toSuperview newSuperview: UIView?) {
        if let view = newSuperview {
            __ecStaticViewEventPublisher?.send(event: .moveToSuperview(.before), for: view)
            self.easy.event.send(event: .moveToSuperview(.before), for: view)
        }else{
            __ecStaticViewEventPublisher?.send(event: .removeFromSuperview(.before))
            self.easy.event.send(event: .removeFromSuperview(.before))
        }
        self.__ecEventWillMove(toSuperview: newSuperview)
    }
    @objc func __ecEventDidMoveToSuperview() {
        self.__ecEventDidMoveToSuperview()
        if let view = self.superview {
            __ecStaticViewEventPublisher?.send(event: .moveToSuperview(.after), for: view)
            self.easy.event.send(event: .moveToSuperview(.after), for: view)
        }else{
            __ecStaticViewEventPublisher?.send(event: .removeFromSuperview(.after))
            self.easy.event.send(event: .removeFromSuperview(.after))
        }
    }
    @objc func __ecEventWillMove(toWindow newWindow: UIWindow?) {
        if let view = newWindow {
            __ecStaticViewEventPublisher?.send(event: .moveToWindow(.before), for: view)
            self.easy.event.send(event: .moveToWindow(.before), for: view)
        }else{
            __ecStaticViewEventPublisher?.send(event: .removeFromWindow(.before))
            self.easy.event.send(event: .removeFromWindow(.before))
        }
        self.__ecEventWillMove(toWindow: newWindow)
    }
    @objc func __ecEventDidMoveToWindow() {
        self.__ecEventDidMoveToWindow()
        if let view = self.superview {
            __ecStaticViewEventPublisher?.send(event: .moveToWindow(.after), for: view)
            self.easy.event.send(event: .moveToWindow(.after), for: view)
        }else{
            __ecStaticViewEventPublisher?.send(event: .removeFromWindow(.after))
            self.easy.event.send(event: .removeFromWindow(.after))
        }
    }
}
extension EasyCoding where Base: UIView{
    ///给UIViewController添加事件
    public var event: ECViewEventPublisher {
        return self.bindAssociatedObject("ec_extension_event_publisher")
    }
    ///给UIViewController添加事件
    public static var event: ECViewEventPublisher {
        return ECViewEventPublisher.easy.createSingleton(getter: { return __ecStaticViewEventPublisher }, setter: { (publisher) in
            __ecStaticViewEventPublisher = publisher
        })
    }
    ///注册事件
    public func when<EventParameterType>(_ event: ECViewEvent, identifier: String? = nil, block: @escaping (EventParameterType)->Void) {
        self.event.when(event, identifier: identifier, block: block)
    }
    ///注册事件
    public static func when<EventParameterType>(_ event: ECViewEvent, identifier: String? = nil, block: @escaping (EventParameterType)->Void) {
        self.event.when(event, identifier: identifier, block: block)
    }
}

extension ECEventPublisherType where Self: UIView {
    ///注册事件
    public func when<EventParameterType>(easy event: ECViewEvent, identifier: String? = nil, block: @escaping (EventParameterType)->Void) {
        self.easy.event.when(event, identifier: identifier, block: block)
    }
}
