//
//  HourWeatherCell.swift
//  Sweather Weather
//
//  Created by Dima Zhiltsov on 14.05.2025.
//

import UIKit

final class HourWeatherCell: UICollectionViewCell {
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Constants.stackSpacing
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: Constants.timeFontSize, weight: .regular)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private lazy var weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: Constants.temperatureFontSize, weight: .medium)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        setupAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupViews() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(timeLabel)
        stackView.addArrangedSubview(weatherIconImageView)
        stackView.addArrangedSubview(temperatureLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            weatherIconImageView.widthAnchor.constraint(equalToConstant: Constants.iconSize),
            weatherIconImageView.heightAnchor.constraint(equalToConstant: Constants.iconSize)
        ])
    }
    
    private func setupAppearance() {
        backgroundColor = .clear
    }
}

// MARK: - Public methods
extension HourWeatherCell {
    func configure(with model: ForecastDayModel.Hour) {
        timeLabel.text = model.visibleHour
        weatherIconImageView.image = UIImage(systemName: model.condition.iconName)
        temperatureLabel.text = String(format: "%.0f°C", model.tempC)
    }
}

// MARK: - Constants
extension HourWeatherCell {
    private enum Constants {
        static let stackSpacing: CGFloat = 4
        static let iconSize: CGFloat = 24
        static let timeFontSize: CGFloat = 14
        static let temperatureFontSize: CGFloat = 16
    }
}
