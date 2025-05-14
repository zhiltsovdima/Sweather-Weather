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
            weatherView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.padding),
            weatherView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.padding),
            
            weatherView.widthAnchor.constraint(lessThanOrEqualToConstant: Constants.maxWidth),
            weatherView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    private func setupAppearance() {
        backgroundColor = .clear
        selectionStyle = .none
    }
}

extension CurrentWeatherCell {
    
    // MARK: - Public methods
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
