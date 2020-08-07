//
//  TestController.swift
//  EasyCoding_Example
//
//  Created by JY_NEW on 2020/8/4.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import MediaPlayer

class TestController: ViewController<TestView> {
    
    let volumeView = MPVolumeView()      //}  为了隐藏声音弹框
    var volumeViewSlider = UISlider()    //}  为了隐藏声音弹框
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for view in volumeView.subviews{
            if view.classForCoder.description() == "MPVolumeSlider"{
                volumeViewSlider = UISlider()
                break
            }
        }
        volumeView.frame = CGRect(x: -100,y: -100,width: 40,height: 40)
        self.view.addSubview(volumeView)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let session = AVAudioSession.sharedInstance()
        session.addObserver(self, forKeyPath: "outputVolume", options: .new, context: nil)
//        try? session.setCategory(.ambient)
//        try? session.setActive(true, options: .notifyOthersOnDeactivation)
//        NotificationCenter.default.addObserver(self,selector: #selector(self.changeVolumSlider),name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"),object: nil)
//        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        super.viewWillDisappear(animated)
    }
    
    @objc func changeVolumSlider(notification:NSNotification){ //记得参数加上，才能得到信息
           if let volum:Float = notification.userInfo?["AVSystemController_AudioVolumeNotificationParameter"]as! Float?{
               print("蓝牙拦截\(volum)")
           }
       }
}
class TestView: Page {
    
}
