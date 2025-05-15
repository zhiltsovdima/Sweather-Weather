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
    func heightForRowAt(_ tableView: UITableView, _ indexPath: IndexPath) -> CGFloat
}

final class MainPresenter {
    
    enum ViewState {
        case loading
        case loaded
        case failed
    }
    
    private enum TableDataType: CaseIterable {
        case currentWeather
        case hourlyForecast
        case dailyForecast
    }
    
    private weak var view: MainViewInput?
    private var router: MainRouter?
    private let weatherService: WeatherService
    private let locationService: LocationService
    private let alertFactory: AlertFactoryProtocol
    
    private var currentLocation: UserLocation?
    private var currentWeather: CurrentWeatherModel?
    private var dailyForecast: [ForecastDayModel] = []
    
    private var currentState: ViewState = .loading {
        didSet {
            view?.updateState(currentState)
        }
    }
    
    init(
        view: MainViewInput,
        router: MainRouter,
        weatherService: WeatherService,
        locationService: LocationService,
        alertFactory: AlertFactoryProtocol
    ) {
        self.view = view
        self.router = router
        self.weatherService = weatherService
        self.locationService = locationService
        self.alertFactory = alertFactory
    }
}

// MARK: - MainPresenterDelegate
extension MainPresenter: MainPresenterDelegate {
    
    func viewDidLoad() {
        currentState = .loading
        Task {
            await fetchWeatherData()
        }
    }
    
    func refreshWeather() {
        if currentState == .failed {
            currentState = .loading
        }
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
            cell.configure(with: currentWeather)
            return cell
        case .hourlyForecast:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: HourlyForecastCell.className,
                for: indexPath
            ) as? HourlyForecastCell else {
                return UITableViewCell()
            }
            let hours = getHourlyForecast()
            cell.configure(with: hours)
            return cell
        case .dailyForecast:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: DailyForecastCell.className,
                for: indexPath
            ) as? DailyForecastCell else {
                return UITableViewCell()
            }
            cell.configure(with: dailyForecast)
            return cell
        }
    }
    
    func heightForRowAt(_ tableView: UITableView, _ indexPath: IndexPath) -> CGFloat {
        let dataType = TableDataType.allCases[indexPath.row]

        switch dataType {
        case .currentWeather:
            return 250
        case .hourlyForecast:
            return 125
        case .dailyForecast:
            return UITableView.automaticDimension
        }
    }
    
}

// MARK: - Private Methods
private extension MainPresenter {
    
    private func getCurrentLocation() async -> UserLocation {
        do {
            return try await locationService.getCurrentLocation()
        } catch {
            return UserLocation.defaultLocation
        }
    }
    
    private func fetchWeatherForLocation(_ location: UserLocation) async {
        do {
            let forecastResponse = try await weatherService.fetchForecast(for: location)
            currentWeather = CurrentWeatherModel(from: forecastResponse)
            dailyForecast = forecastResponse.forecast.forecastday.map {
                ForecastDayModel(from: $0)
            }
            view?.updateState(.loaded)
        } catch let netError as NetworkError {
            view?.updateState(.failed)
            showAlert(title: "Network Error", netError.message)
        } catch {
            view?.updateState(.failed)
            print(error.localizedDescription)
        }
    }
    
    private func showAlert(title: String, _ message: String) {
        DispatchQueue.main.async {
            let alert = self.alertFactory.createAlertInfo(with: title, message, nil)
            self.router?.showAlert(alert)
        }
    }
    
    private func updateTableView() {
        view?.reloadData()
    }
    
    private func getHourlyForecast() -> [ForecastDayModel.Hour] {
        guard !dailyForecast.isEmpty else { return [] }
        
        let now = Date()
        let calendar = Calendar.current
        let currentHour = calendar.component(.hour, from: now)
        
        let currentDayHours = dailyForecast[0].hour.filter { hour in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            guard let hourDate = dateFormatter.date(from: hour.time) else { return false }
            let hourValue = calendar.component(.hour, from: hourDate)
            return hourValue >= currentHour
        }
        
        let nextDayHours = dailyForecast.count > 1 ? dailyForecast[1].hour : []
        
        return currentDayHours + nextDayHours
    }
}
