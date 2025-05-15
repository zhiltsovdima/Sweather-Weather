//
//  CurrentWeatherCell.swift
//  Sweather Weather
//
//  Created by Dima Zhiltsov on 14.05.2025.
//

import UIKit

final class CurrentWeatherCell: UITableViewCell {
    
    private lazy var weatherView: CurrentWeatherView = {
        let view = CurrentWeatherView()
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
        contentView.addSubview(weatherView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            weatherView.widthAnchor.constraint(lessThanOrEqualToConstant: Constants.maxWidth),
            weatherView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            weatherView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    private func setupAppearance() {
        backgroundColor = .clear
        selectionStyle = .none
    }
}

// MARK: - Public methods
extension CurrentWeatherCell {
    func configure(with model: CurrentWeatherModel?) {
        weatherView.update(with: model)
    }
}

// MARK: - Constants
extension CurrentWeatherCell {
    private enum Constants {
        static let padding: CGFloat = 16
        static let maxWidth: CGFloat = 400
    }
}
