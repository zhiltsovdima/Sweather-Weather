//
//  DailyForecastView.swift
//  Sweather Weather
//
//  Created by Dima Zhiltsov on 15.05.2025.
//

import UIKit

final class DailyForecastView: UIView {
    private lazy var backgroundContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = Constants.cornerRadius
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var backgroundEffectView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        let view = UIVisualEffectView(effect: effect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.isScrollEnabled = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = Constants.cellHeight
        tableView.register(DayWeatherCell.self, forCellReuseIdentifier: DayWeatherCell.className)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    override var intrinsicContentSize: CGSize {
        let height = CGFloat(forecastDays.count) * Constants.cellHeight + 2 * Constants.padding
        return CGSize(width: UIView.noIntrinsicMetric, height: height)
    }
    
    private var forecastDays: [ForecastDayModel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        setupAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup Views
extension DailyForecastView {
    private func setupViews() {
        addSubview(backgroundContainerView)
        backgroundContainerView.addSubview(backgroundEffectView)
        backgroundContainerView.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundContainerView.topAnchor.constraint(equalTo: topAnchor),
            backgroundContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            backgroundEffectView.topAnchor.constraint(equalTo: backgroundContainerView.topAnchor),
            backgroundEffectView.leadingAnchor.constraint(equalTo: backgroundContainerView.leadingAnchor),
            backgroundEffectView.trailingAnchor.constraint(equalTo: backgroundContainerView.trailingAnchor),
            backgroundEffectView.bottomAnchor.constraint(equalTo: backgroundContainerView.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: backgroundContainerView.topAnchor, constant: Constants.padding),
            tableView.leadingAnchor.constraint(equalTo: backgroundContainerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: backgroundContainerView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: backgroundContainerView.bottomAnchor, constant: -Constants.padding)
        ])
    }
    
    private func setupAppearance() {
        backgroundColor = .clear
    }
}

// MARK: - Public methods
extension DailyForecastView {
    func update(with days: [ForecastDayModel]) {
        self.forecastDays = Array(days.prefix(7))
        tableView.reloadData()
        layoutIfNeeded()
        invalidateIntrinsicContentSize()
    }
}

// MARK: - UITableViewDataSource
extension DailyForecastView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        forecastDays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: DayWeatherCell.className,
            for: indexPath
        ) as? DayWeatherCell else {
            return UITableViewCell()
        }
        
        let day = forecastDays[indexPath.row]
        let isToday = indexPath.row == 0
        cell.configure(with: day, isToday: isToday)
        
        return cell
    }
}

extension DailyForecastView: UITableViewDelegate {}

extension DailyForecastView {
    private enum Constants {
        static let cornerRadius: CGFloat = 16
        static let padding: CGFloat = 16
        static let cellHeight: CGFloat = 54
    }
}
