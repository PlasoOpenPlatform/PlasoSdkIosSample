//
//  AppDelegate.swift
//  PlasoSdkDemoForiOS
//
//  Created by Cherfry on 2021/11/3.
//

import UIKit
import Material

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
    
        let liveConfigVC = LiveConfigViewController()
        let toolBarVC = PlasoToolbarController.init(rootViewController: liveConfigVC)
        let leftVC = LeftViewController()
        leftVC.liveConfigVC = liveConfigVC
        let nav = NavigationDrawerController.init(rootViewController: toolBarVC, leftViewController: leftVC)
        print("SandBox:" + NSHomeDirectory())
        window = UIWindow()
        window?.frame = UIScreen.main.bounds
        window?.backgroundColor = UIColor.white
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        return true
    }


}

