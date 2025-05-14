//
//  MainViewController.swift
//  Sweather Weather
//
//  Created by Dima Zhiltsov on 13.05.2025.
//

import UIKit

protocol MainViewInput: AnyObject {
    func reloadData()
}

final class MainViewController: UIViewController {
    
    var presenter: MainPresenterDelegate?
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(CurrentWeatherCell.self, forCellReuseIdentifier: CurrentWeatherCell.className)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        setupAppearance()
        presenter?.viewDidLoad()
    }
}

// MARK: - Setup Views
extension MainViewController {
    
    private func setupViews() {
        view.addSubview(backgroundImageView)
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupAppearance() {
        backgroundImageView.image = UIImage(named: Constants.backgroundImageName)
    }
}

// MARK: - MainViewInput
extension MainViewController: MainViewInput {
    func reloadData() {
        guard Thread.isMainThread else {
            DispatchQueue.main.async {
                self.reloadData()
            }
            return
        }
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let presenter else { return 0 }
        return presenter.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let presenter else { return UITableViewCell() }
        return presenter.cellForRowAt(tableView, indexPath)
    }
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {

}

// MARK: - Constants
extension MainViewController {
    private enum Constants {
        static let backgroundImageName = "background"
    }
}
