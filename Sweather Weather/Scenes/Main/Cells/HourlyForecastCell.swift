//
//  HourlyForecastCell.swift
//  Sweather Weather
//
//  Created by Dima Zhiltsov on 14.05.2025.
//

import UIKit

final class HourlyForecastCell: UITableViewCell {
    
    private lazy var hourlyForecastView: HourlyForecastView = {
        let view = HourlyForecastView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
        setupAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupViews() {
        contentView.addSubview(hourlyForecastView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            hourlyForecastView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.padding),
            hourlyForecastView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hourlyForecastView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hourlyForecastView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.padding)
        ])
    }
    
    private func setupAppearance() {
        backgroundColor = .clear
        selectionStyle = .none
    }
}

// MARK: - Public methods
extension HourlyForecastCell {
    func configure(with model: [ForecastDayModel.Hour]) {
        hourlyForecastView.update(with: model)
    }
}

// MARK: - Constants
extension HourlyForecastCell {
    private enum Constants {
        static let padding: CGFloat = 8
    }
}
