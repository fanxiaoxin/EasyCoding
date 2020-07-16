//
//  FlowCenter.swift
//  Alamofire
//
//  Created by Fanxx on 2019/8/8.
//

import UIKit

open class ECFlowCenter: ECFlow {
    public typealias Queue = Int
    public static let mainQueue: Queue = 0
    private static var flowCenters:[ECFlowCenter] = []
    //添加流程进队列并排队启动
    @discardableResult
    public static func add(_ ECFlow: ECFlow, queue: Queue = mainQueue) -> Bool {
        let flowCenter: ECFlowCenter
        if let fc = flowCenters.first(where: { $0.queue == queue }) {
            flowCenter = fc
        }else{
            flowCenter = ECFlowCenter(queue)
            flowCenters.append(flowCenter)
        }
        flowCenter.next(ECFlow)
        //若正在跑也不会重复执行，但执行完会执行下一步
        return flowCenter.start()
    }
    ///特殊流程，可重复触发
    open override func doAction() -> Bool {
        self.isTriggered = false
        return super.doAction()
    }
    
    private let queue: Queue
    private init(_ queue: Queue) {
        self.queue = queue
        super.init()
    }
}
extension ECFlow {
    ///放入执行队列
    public func activate(queue: ECFlowCenter.Queue = ECFlowCenter.mainQueue) {
        ECFlowCenter.add(self, queue: queue)
    }
}
