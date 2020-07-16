//
//  FlowStep.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/8/2.
//

import UIKit

///单个流程
open class ECFlowStep {
    ///上一个流程的触发条件
    open var trigerStates: [State] = []
    ///后续流程，同个结果仅支持一个分支
    open var nextSteps: [ECFlowStep]?
    ///所属流程
    public internal(set) weak var flow: ECFlow?
    ///是否已触发，避免重复触发
    public var isTriggered = false
    ///当前步骤是否已完成，避免重复调用下一步骤
    public var isFinished = false
    ///当前状态
    open var state: State = .begin {
        didSet {
            ///若已结束则不可再触发
            if !self.isFinished {
                self.isFinished = self.state.isFinished
                self.flow?.onStateChanged(self)
            }
        }
    }
    @discardableResult
    open func doAction() -> Bool {
        if !self.isTriggered {
            self.isTriggered = true
            self.action()
            return true
        }else{
            return false
        }
    }
    open func action() {
        
    }
    
}
///使用Block的单个流程
open class ECBlockFlowStep: ECFlowStep {
    ///启动
    public let actionBlock: (ECFlowStep) -> Void
    public init(action block: @escaping (ECFlowStep) -> Void) {
        self.actionBlock = block
    }
    open override func action() {
        self.actionBlock(self)
    }
}
