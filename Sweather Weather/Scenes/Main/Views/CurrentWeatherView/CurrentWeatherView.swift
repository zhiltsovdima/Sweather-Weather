//
//  CurrentWeatherView.swift
//  Sweather Weather
//
//  Created by Dima Zhiltsov on 14.05.2025.
//

import UIKit

final class CurrentWeatherView: UIView {
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Constants.stackSpacing
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: Constants.cityFontSize, weight: .bold)
        label.textColor = .white
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
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var conditionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: Constants.conditionFontSize, weight: .regular)
        label.textColor = .white
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
        addSubview(stackView)
        stackView.addArrangedSubview(cityLabel)
        stackView.addArrangedSubview(weatherIconImageView)
        stackView.addArrangedSubview(temperatureLabel)
        stackView.addArrangedSubview(conditionLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.padding),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.padding),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.padding),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.padding),
            
            weatherIconImageView.widthAnchor.constraint(equalToConstant: Constants.iconSize),
            weatherIconImageView.heightAnchor.constraint(equalToConstant: Constants.iconSize)
        ])
    }
    
    private func setupAppearance() {
        backgroundColor = .clear
    }
}

// MARK: - Public methods
extension CurrentWeatherView {
    
    func update(with model: CurrentWeatherModel?) {
        guard let model else { return }
        cityLabel.text = model.city
        weatherIconImageView.image = UIImage(systemName: model.condition.iconName)
        temperatureLabel.text = model.temperatureCelciusString
        conditionLabel.text = model.condition.text
    }
    
}

// MARK: - Constants
extension CurrentWeatherView {
    private enum Constants {
        static let padding: CGFloat = 16
        static let stackSpacing: CGFloat = 8
        
        static let iconSize: CGFloat = 60
        
        static let cityFontSize: CGFloat = 24
        static let temperatureFontSize: CGFloat = 20
        static let conditionFontSize: CGFloat = 16
    }
}
