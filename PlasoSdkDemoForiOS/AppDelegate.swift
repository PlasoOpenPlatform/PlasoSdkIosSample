//
//  AppDelegate.swift
//  PlasoStyleUpimeDemo
//
//  Created by liyang on 2020/12/28.
//  Copyright © 2020 plaso. All rights reserved.
//

import UIKit
import Material
//import DoraemonKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        print("SandBox:" + NSHomeDirectory())
        if #unavailable(iOS 13) {
            
            let rootVC = MainViewController()

            window = UIWindow()
            window?.frame = UIScreen.main.bounds
            window?.backgroundColor = UIColor.white
            window?.rootViewController = rootVC
            window?.makeKeyAndVisible()

//            DoraemonManager.shareInstance().install(withPid: "710c18534b573e3d9fe465c043f2d1cf")
        }
        let basePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
        if let path = basePath {
            let newPath = path + "/Logs"
            YXTLoggerManager.shareInstance().setLogDir(newPath)
        }
        return true
    }
}


@available(iOS 13.0, *)
extension AppDelegate {
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

