//
//  MainViewController.swift
//  Sweather Weather
//
//  Created by Dima Zhiltsov on 13.05.2025.
//

import UIKit

protocol MainViewInput: AnyObject {
    func reloadData()
    func updateState(_ state: MainPresenter.ViewState)
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
        tableView.register(HourlyForecastCell.self, forCellReuseIdentifier: HourlyForecastCell.className)
        tableView.register(DailyForecastCell.self, forCellReuseIdentifier: DailyForecastCell.className)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshWeather), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .large)
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.color = .white
        loader.hidesWhenStopped = true
        return loader
    }()
    
    private lazy var retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Retry", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
        button.isHidden = true
        return button
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
        view.addSubview(retryButton)
        view.addSubview(loader)
        tableView.refreshControl = refreshControl
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalPadding),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            retryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            retryButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            retryButton.widthAnchor.constraint(equalToConstant: Constants.retryButtonWidth),
            retryButton.heightAnchor.constraint(equalToConstant: Constants.retryButtonHeight)
        ])
    }
    
    private func setupAppearance() {
        backgroundImageView.image = UIImage(named: Constants.backgroundImageName)
    }
    
    @objc
    private func refreshWeather() {
        presenter?.refreshWeather()
        refreshControl.endRefreshing()
    }
    
    @objc
    private func retryTapped() {
        presenter?.refreshWeather()
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
    
    func updateState(_ state: MainPresenter.ViewState) {
        guard Thread.isMainThread else {
            DispatchQueue.main.async {
                self.updateState(state)
            }
            return
        }
        switch state {
        case .loading:
            tableView.isHidden = true
            retryButton.isHidden = true
            loader.startAnimating()
        case .loaded:
            tableView.isHidden = false
            retryButton.isHidden = true
            loader.stopAnimating()
            tableView.reloadData()
        case .failed:
            tableView.isHidden = true
            retryButton.isHidden = false
            loader.stopAnimating()
        }
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let presenter else { return UITableView.automaticDimension }
        return presenter.heightForRowAt(tableView, indexPath)
    }
}

// MARK: - Constants
extension MainViewController {
    private enum Constants {
        static let backgroundImageName = "background"
        static let horizontalPadding: CGFloat = 16
        static let cellSpacing: CGFloat = 8
        
        static let retryButtonWidth: CGFloat = 120
        static let retryButtonHeight: CGFloat = 44
    }
}
