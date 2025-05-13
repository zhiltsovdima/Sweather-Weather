//
//  MainRouter.swift
//  Sweather Weather
//
//  Created by Dima Zhiltsov on 13.05.2025.
//

import UIKit

class MainRouter {
    
    private var window: UIWindow
    private let sceneFactory: SceneFactory
    
    init(window: UIWindow) {
        self.window = window
        
        sceneFactory = SceneFactoryImpl()
    }
    
    func showMainViewControllerInWindow() {
        guard let mainViewController = sceneFactory.createMainViewController(with: self) else {
            return
        }
        
        window.rootViewController = mainViewController
        window.makeKeyAndVisible()
    }
    
}
