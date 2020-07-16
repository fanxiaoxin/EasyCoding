//
//  FlowController.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/11/26.
//

import UIKit

public protocol ECFlowControllerType: ECViewControllerType {
    var onFlow: ((ECFlowStep.State) -> Void)? { get set }
}
open class ECControllerFlow: ECFlow {
    open var controller: UIViewController?
    public override var flow: ECFlow? {
        didSet {
            if self.controller == nil {
                if let f = self.flow as? ECControllerFlow {
                    self.controller = f.controller
                }
            }
        }
    }
    public init(_ controller: ECFlowControllerType? = nil) {
        self.controller = controller
        super.init()
    }
}
open class ECControllerFlowStep: ECFlowStep {
    public var controller: ECFlowControllerType? {
        didSet {
            self.setControllerFlowAction()
        }
    }
    func setControllerFlowAction() {
        self.controller?.onFlow = { [weak self] state in
            self?.state = state
            ///若是结束则将onFlow置为空，防止二次调用
            if state.isFinished {
                self?.controller?.onFlow = nil
            }
        }
    }
    public init(_ controller: ECFlowControllerType?) {
        self.controller = controller
        super.init()
        self.setControllerFlowAction()
    }
    open override func action() {
        if let c = self.controller {
            (self.flow as? ECControllerFlow)?.controller?.load(c)
        }else{
            self.state = .success
        }
    }
}
extension ECFlow {
    @discardableResult
    open func branch(_ controller: ECFlowControllerType, for state: State...) -> Self {
        let step = ECControllerFlowStep(controller)
        step.trigerStates = state
        return self.branch(step)
    }
    @discardableResult
    open func next(_ controller: ECFlowControllerType, for state: State...) -> Self {
        let step = ECControllerFlowStep(controller)
        step.trigerStates = state
        return self.next(step)
    }
}
