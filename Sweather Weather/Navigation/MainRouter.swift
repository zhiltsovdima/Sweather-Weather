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
    
    private var currentViewController: UIViewController?
    
    init(window: UIWindow) {
        self.window = window
        
        sceneFactory = SceneFactoryImpl()
    }
    
    func showMainViewControllerInWindow() {
        guard let mainViewController = sceneFactory.createMainViewController(with: self) else {
            return
        }
        currentViewController = mainViewController
        window.rootViewController = mainViewController
        window.makeKeyAndVisible()
    }
    
}

extension MainRouter {
    func showAlert(_ alert: UIAlertController) {
        currentViewController?.present(alert, animated: true, completion: nil)
    }
}
