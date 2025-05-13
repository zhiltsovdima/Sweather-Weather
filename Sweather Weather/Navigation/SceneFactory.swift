//
//  SceneFactory.swift
//  Sweather Weather
//
//  Created by Dima Zhiltsov on 13.05.2025.
//

import UIKit

protocol SceneFactory {
    func createMainViewController(with router: MainRouter) -> UIViewController?
}

final class SceneFactoryImpl: SceneFactory {
    
    func createMainViewController(with router: MainRouter) -> UIViewController? {
        let viewController = MainViewController()
        let presenter = MainPresenter(view: viewController, router: router)
        viewController.presenter = presenter
        return viewController
    }
}
