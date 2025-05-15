//
//  DailyForecastCell.swift
//  Sweather Weather
//
//  Created by Dima Zhiltsov on 15.05.2025.
//

import UIKit

final class DailyForecastCell: UITableViewCell {
    
    private lazy var dailyForecastView: DailyForecastView = {
        let view = DailyForecastView()
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
        contentView.addSubview(dailyForecastView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            dailyForecastView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.padding),
            dailyForecastView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dailyForecastView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            dailyForecastView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.padding)
        ])
    }
    
    private func setupAppearance() {
        backgroundColor = .clear
        selectionStyle = .none
    }
}

// MARK: - Public methods
extension DailyForecastCell {
    func configure(with model: [ForecastDayModel]) {
        dailyForecastView.update(with: model)
    }
}

// MARK: - Constants
extension DailyForecastCell {
    private enum Constants {
        static let padding: CGFloat = 8
    }
}
