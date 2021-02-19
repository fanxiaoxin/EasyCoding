//
//  EasyPresentAnimation_Group.swift
//  EasyCoding
//
//  Created by JY_NEW on 2020/7/8.
//

import UIKit

extension EasyPresentAnimation {
    ///多个动画同时做
    public struct Group: EasyPresentAnimationType {
        ///最长的动画时长
        public var duration: TimeInterval {
            if let max = self.animations.max(by: {$0.aniamtion.duration + $0.delay > $1.aniamtion.duration + $1.delay }) {
                return max.aniamtion.duration + max.delay
            }
            return 0
        }
        ///回调队列，默认主队列
        public var completionQueue = DispatchQueue.main
        ///保存所有动画
        ///tag: easy.tag标签，可多个子view打一样的标签，nil代表自身
        ///delay: 每个动画的延时显示
        ///aniamtion: 具体动画
        public var animations: [(tag: Int?, delay: TimeInterval, aniamtion: EasyPresentAnimationType)] = []
        
        public init() {
            
        }
        public func show(view: UIView, completion: (() -> Void)?) {
            let time = Date()
            let duration = self.duration
            for animation in self.animations {
                if let views = view.easy.viewsWithTag(animation.tag) {
                    if animation.delay > 0 {
                        //UI只能在主线程
                        DispatchQueue.main.asyncAfter(deadline: .now() + animation.delay) {
                            views.forEach({ animation.aniamtion.show(view: $0, completion: nil)})
                        }
                    }else{
                        views.forEach({ animation.aniamtion.show(view: $0, completion: nil)})
                    }
                }
            }
            self.complete(duration: duration + time.timeIntervalSinceNow, completion: completion)
        }
        
        public func dismiss(view: UIView, completion: (() -> Void)?) {
            let time = Date()
            let duration = self.duration
            for animation in self.animations {
                if let views = view.easy.viewsWithTag(animation.tag) {
                    //隐藏的延时跟显示反过来，取最长时长减去开始延时和动画本身时长
                    let delay = duration - animation.aniamtion.duration - animation.delay
                    if delay > 0 {
                        //UI只能在主线程
                        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                            views.forEach({ animation.aniamtion.dismiss(view: $0, completion: nil)})
                        }
                    }else{
                        views.forEach({ animation.aniamtion.dismiss(view: $0, completion: nil)})
                    }
                }
            }
            self.complete(duration: duration + time.timeIntervalSinceNow, completion: completion)
        }
        
        func complete(duration: TimeInterval, completion: (() -> Void)?) {
            if let cpn = completion {
                if duration <= 0 {
                    cpn()
                }else{
                    ///手动延时调用完成事件
                    self.completionQueue.asyncAfter(deadline: .now() + duration) {
                        cpn()
                    }
                }
            }
        }
    }
}
