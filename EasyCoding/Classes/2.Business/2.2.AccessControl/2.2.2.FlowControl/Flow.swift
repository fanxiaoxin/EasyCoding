//
//  Flow.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/8/2.
//

import UIKit

open class ECFlow: ECFlowStep {
    //互斥锁，用于读写子流程
    //    public let stepsOperatingLock = DispatchQueue(label: "ECECFlowSteps", attributes: .concurrent)
    ///当前执行流程，根据执行情况流动，为空时则结束，若是分支未结束流程，则不会设置在此
    public var currentStep: ECFlowStep? = nil {
        didSet {
            //当清空当前流程时，创建流程也会重置
            if self.currentStep == nil {
                self.currentBuildStep = nil
            }
        }
    }
    ///当前创建流程
    internal weak var currentBuildStep: ECFlowStep? = nil {
        didSet {
            if self.currentBuildStep != nil && self.currentStep == nil {
                self.currentStep = self.currentBuildStep
            }
        }
    }
    public init(_ step: ECFlowStep? = nil) {
        self.currentStep = step
        super.init()
        step?.flow = self
    }
    open override func action() {
        self.start()
    }
    @discardableResult
    open func start() -> Bool {
        if let step = self.currentStep {
            return step.doAction()
        }else{
            self.finish()
            return false
        }
    }
    open func finish() {
        self.state = .success
    }
    internal func onStateChanged(_ step: ECFlowStep) {
        //只针对当前流程操作，防止旧流程串流打乱流程
        if step === self.currentStep {
            let state = step.state
            if let current = self.currentStep {
                //                self.stepsOperatingLock.sync {
                if let steps = current.nextSteps {
                    for s in steps {
                        if s.trigerStates.contains(state) || (s.trigerStates.count == 0 && state.isFinished) {
                            //仅当结束时会转移当前流程
                            if state.isFinished {
                                self.currentStep = s
                            }
                            s.flow = self
                            s.doAction()
                            return
                        }
                    }
                }
                //                }
                //若没有子流程被触发且状态结束，则调用结束方法
                if state.isFinished {
                    self.currentStep = nil
                    self.finish()
                }
            }else{
                self.finish()
            }
        }
    }
}
extension ECFlow {
    ///添加新的分支
    @discardableResult
    public func branch(_ step: ECFlowStep) -> Self {
        //加锁
        //        self.stepsOperatingLock.sync(flags: .barrier) {
        if let current = self.currentBuildStep {
            if current.nextSteps == nil {
                current.nextSteps = [step]
            }else{
                current.nextSteps!.append(step)
            }
        }else{
            self.currentBuildStep = step
        }
        //        }
        step.flow = self
        return self
    }
    ///添加新的分支并当前创建流程指向新的
    @discardableResult
    public func next(_ step: ECFlowStep) -> Self {
        self.branch(step)
        //将当前创建流程指向新的
        self.currentBuildStep = step
        return self
    }
    ///添加新的分支
    @discardableResult
    public func branch(_ step: ECFlowStep, for states: ECFlowStep.State...) -> Self {
        step.trigerStates = states
        return self.branch(step)
    }
    ///添加新的分支并当前创建流程指向新的
    @discardableResult
    public func next(_ step: ECFlowStep, for states: ECFlowStep.State...) -> Self {
        step.trigerStates = states
        return self.next(step)
    }
    ///添加新的分支
    @discardableResult
    public func branch(flow builder: (ECFlow)->Void, for states: ECFlowStep.State...) -> Self {
        let flow = ECFlow()
        builder(flow)
        flow.trigerStates = states
        return self.branch(flow)
    }
    ///添加新的分支并当前创建流程指向新的
    @discardableResult
    public func next(flow builder: (ECFlow)->Void, for states: ECFlowStep.State...) -> Self {
        let flow = ECFlow()
        builder(flow)
        flow.trigerStates = states
        return self.next(flow)
    }
    ///添加新的分支
    @discardableResult
    public func branch(_ action: @escaping (ECFlowStep) -> Void, for states: ECFlowStep.State...) -> Self {
        let step = ECBlockFlowStep(action: action)
        step.trigerStates = states
        return self.branch(step)
    }
    ///添加新的分支并当前创建流程指向新的
    @discardableResult
    public func next(_ action: @escaping (ECFlowStep) -> Void, for states: ECFlowStep.State...) -> Self {
        let step = ECBlockFlowStep(action: action)
        step.trigerStates = states
        return self.next(step)
    }
}
