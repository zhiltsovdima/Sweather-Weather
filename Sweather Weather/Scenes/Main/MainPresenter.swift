//
//  MainPresenter.swift
//  Sweather Weather
//
//  Created by Dima Zhiltsov on 13.05.2025.
//

import UIKit

protocol MainPresenterDelegate: AnyObject {
    func viewDidLoad()
    func refreshWeather()
    
    func numberOfRowsInSection() -> Int
    func cellForRowAt(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell
}

final class MainPresenter {
    private weak var view: MainViewInput?
    private var router: MainRouter?
    private let weatherService: WeatherService
    private let locationService: LocationService
    
    private var currentLocation: UserLocation?
    private var currentWeather: CurrentWeatherModel?
    
    private enum TableDataType: CaseIterable {
        case currentWeather
        case hourlyForecast
        case dailyForecast
    }
    
    init(view: MainViewInput, router: MainRouter, weatherService: WeatherService, locationService: LocationService) {
        self.view = view
        self.router = router
        self.weatherService = weatherService
        self.locationService = locationService
    }
}

// MARK: - MainPresenterDelegate
extension MainPresenter: MainPresenterDelegate {
    func viewDidLoad() {
        Task {
            await fetchWeatherData()
        }
    }
    
    func refreshWeather() {
        Task {
            await fetchWeatherData()
        }
    }
    
    func fetchWeatherData() async {
        let location = await getCurrentLocation()
        currentLocation = location
        await fetchWeatherForLocation(location)
        updateTableView()
    }
    
    func numberOfRowsInSection() -> Int {
        TableDataType.allCases.count
    }
    
    func cellForRowAt(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let dataType = TableDataType.allCases[indexPath.row]
        
        switch dataType {
        case .currentWeather:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CurrentWeatherCell.className,
                for: indexPath
            ) as? CurrentWeatherCell else {
                return UITableViewCell()
            }
            if let model = currentWeather {
                cell.configure(with: model)
            } else {
                cell.configure(with: nil)
            }
            return cell
            
        default: return UITableViewCell()
        }
    }
    
    // MARK: - Private Methods
    
    private func getCurrentLocation() async -> UserLocation {
        do {
            return try await locationService.getCurrentLocation()
        } catch {
            // Show alert for example?
            return UserLocation.defaultLocation
        }
    }
    
    private func fetchWeatherForLocation(_ location: UserLocation) async {
        do {
            let response = try await weatherService.fetchCurrentWeather(for: location)
            currentWeather = CurrentWeatherModel(from: response)
        } catch let netError as NetworkError {
            print(netError.message)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func updateTableView() {
        view?.reloadData()
    }
    
}
