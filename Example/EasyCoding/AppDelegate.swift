//
//  AppDelegate.swift
//  EasyCoding
//
//  Created by fanxiaoxin_1987@126.com on 06/02/2020.
//  Copyright (c) 2020 fanxiaoxin_1987@126.com. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var thread: Thread?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UINavigationBar.appearance().isTranslucent = false
        
//        let str = "http://www.baidu.com/abc/def/eeee.json"
//        print(str.easy.first(-(str as NSString).lastPathComponent.count))
        
//        var haha: Int? = 5
//        print(haha < 6)
//        haha = nil
//        print(haha < 6)
//        haha = 8
//        print(haha < 6)
        
//        let thread = Thread(target: self, selector: #selector(self.test), object: nil)
//        self.thread = thread
//        thread.start()
        self.test()
        return true
    }
    @objc func test() {
        let observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, CFRunLoopActivity.allActivities.rawValue, true, 0) { (observer, activity) in
            switch activity {
            case .entry: print("进入")
            case .beforeTimers: print("即将处理Timer事件")
            case .beforeSources: print("即将处理Source事件")
            case .beforeWaiting: print("即将休眠")
            case .afterWaiting: print("被唤醒")
            case .exit: print("退出RunLoop")
            default: break
            }
        }
        CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, CFRunLoopMode.defaultMode)
        /*
        let context = CFRunLoopSourceContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil, equal: nil, hash: nil) { (_, runloop, mode) in
            
        } cancel: { (_, runloop, mode) in
            
        } perform: { (_) in
            
        }*/

        
        
//        RunLoop.current.run()
    }
    @objc func timer() {
        print("mode: \(String(describing: RunLoop.current.currentMode))")
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

