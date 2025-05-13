//
//  MainPresenter.swift
//  Sweather Weather
//
//  Created by Dima Zhiltsov on 13.05.2025.
//

import Foundation

protocol MainPresenterDelegate: AnyObject {
    
}

final class MainPresenter: MainPresenterDelegate {
    
    private weak var view: MainViewInput?
    private var router: MainRouter?
    
    init(view: MainViewInput, router: MainRouter) {
        self.view = view
        self.router = router
    }
}
