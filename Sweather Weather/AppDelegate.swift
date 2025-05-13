//
//  AppDelegate.swift
//  Sweather Weather
//
//  Created by Dima Zhiltsov on 13.05.2025.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var rootRouter: MainRouter?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        if let window {
            rootRouter = MainRouter(window: window)
            rootRouter?.showMainViewControllerInWindow()
        }
        
        return true
    }

}
