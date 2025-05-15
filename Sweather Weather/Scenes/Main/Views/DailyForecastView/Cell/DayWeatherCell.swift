//
//  DayWeatherCell.swift
//  Sweather Weather
//
//  Created by Dima Zhiltsov on 15.05.2025.
//

import UIKit

final class DayWeatherCell: UITableViewCell {
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = Constants.elementSpacing
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: Constants.fontSize, weight: .regular)
        label.textColor = .label
        return label
    }()
    
    private lazy var spacer: UIView = {
        let view = UIView()
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return view
    }()
    
    private lazy var weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var maxTempStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.tempStackSpacing
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var maxTempLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.fontSize, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private lazy var minTempStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.tempStackSpacing
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var minTempLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.fontSize, weight: .regular)
        label.textColor = .label
        return label
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
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(dayLabel)
        stackView.addArrangedSubview(spacer)
        stackView.addArrangedSubview(weatherIconImageView)
        stackView.addArrangedSubview(maxTempStackView)
        stackView.addArrangedSubview(minTempStackView)
        
        let maxTempPrefixLabel = UILabel()
        maxTempPrefixLabel.text = "H"
        maxTempPrefixLabel.font = .systemFont(ofSize: Constants.fontSize, weight: .medium)
        maxTempPrefixLabel.textColor = .label
        
        let minTempPrefixLabel = UILabel()
        minTempPrefixLabel.text = "L"
        minTempPrefixLabel.font = .systemFont(ofSize: Constants.fontSize, weight: .regular)
        minTempPrefixLabel.textColor = .label
        
        maxTempStackView.addArrangedSubview(maxTempPrefixLabel)
        maxTempStackView.addArrangedSubview(maxTempLabel)
        
        minTempStackView.addArrangedSubview(minTempPrefixLabel)
        minTempStackView.addArrangedSubview(minTempLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.padding),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.padding),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.padding),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.padding),
            
            maxTempStackView.widthAnchor.constraint(equalTo: minTempStackView.widthAnchor),
            
            weatherIconImageView.widthAnchor.constraint(equalToConstant: Constants.iconSize),
            weatherIconImageView.heightAnchor.constraint(equalToConstant: Constants.iconSize)
        ])
    }
    
    private func setupAppearance() {
        backgroundColor = .clear
        selectionStyle = .none
    }
}
    // MARK: - Public methods
extension DayWeatherCell {
    func configure(with model: ForecastDayModel, isToday: Bool) {
        dayLabel.text = isToday ? "Today" : model.dayOfWeek
        weatherIconImageView.image = UIImage(systemName: model.day.condition.iconName)
        maxTempLabel.text = String(format: "%.0f°C", model.day.maxTempC)
        minTempLabel.text = String(format: "%.0f°C", model.day.minTempC)
    }
}

// MARK: - Constants
extension DayWeatherCell {
    private enum Constants {
        static let padding: CGFloat = 16
        static let elementSpacing: CGFloat = 8
        static let tempStackSpacing: CGFloat = 2
        static let iconSize: CGFloat = 24
        static let fontSize: CGFloat = 16
    }
}
