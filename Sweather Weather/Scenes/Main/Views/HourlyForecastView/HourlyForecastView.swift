//
//  HourlyForecastView.swift
//  Sweather Weather
//
//  Created by Dima Zhiltsov on 14.05.2025.
//

import UIKit

final class HourlyForecastView: UIView {
    
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
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = Constants.cellSpacing
        layout.minimumLineSpacing = Constants.cellSpacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: Constants.padding, bottom: 0, right: Constants.padding)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(HourWeatherCell.self, forCellWithReuseIdentifier: HourWeatherCell.className)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private var hours: [ForecastDayModel.Hour] = []
    
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
        addSubview(backgroundContainerView)
        backgroundContainerView.addSubview(backgroundEffectView)
        backgroundContainerView.addSubview(collectionView)
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
            
            collectionView.topAnchor.constraint(equalTo: backgroundContainerView.topAnchor, constant: Constants.padding),
            collectionView.leadingAnchor.constraint(equalTo: backgroundContainerView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: backgroundContainerView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: backgroundContainerView.bottomAnchor, constant: -Constants.padding)
        ])
    }
    
    private func setupAppearance() {
        backgroundColor = .clear
    }
}

// MARK: - Public Methods
extension HourlyForecastView {
    func update(with hours: [ForecastDayModel.Hour]) {
        self.hours = hours
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension HourlyForecastView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        hours.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HourWeatherCell.className,
            for: indexPath
        ) as? HourWeatherCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: hours[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HourlyForecastView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: Constants.cellWidth, height: Constants.cellHeight)
    }
}

// MARK: - Constants
extension HourlyForecastView {
    private enum Constants {
        static let cornerRadius: CGFloat = 16
        static let padding: CGFloat = 16
        
        static let cellSpacing: CGFloat = 8
        static let cellWidth: CGFloat = 60
        static let cellHeight: CGFloat = 80
    }
}
