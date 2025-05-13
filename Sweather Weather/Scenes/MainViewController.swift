//
//  MainViewController.swift
//  Sweather Weather
//
//  Created by Dima Zhiltsov on 13.05.2025.
//

import UIKit

protocol MainViewInput: AnyObject {
    
}

final class MainViewController: UIViewController {
    
    var presenter: MainPresenterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
    }
    
}

extension MainViewController: MainViewInput {
    
}
