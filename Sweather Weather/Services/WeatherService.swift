//
//  WeatherService.swift
//  Sweather Weather
//
//  Created by Dima Zhiltsov on 13.05.2025.
//

import Foundation

protocol WeatherService: AnyObject {
    func fetchCurrentWeather(for location: UserLocation) async throws -> CurrentWeatherResponse
    func fetchForecast(for location: UserLocation) async throws -> ForecastResponse
}

final class WeatherServiceImpl: WeatherService {
    
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchCurrentWeather(for location: UserLocation) async throws -> CurrentWeatherResponse {
        let request = try WeatherAPI
            .getCurrent(location)
            .makeRequest()
        let requestCofig = RequestConfig(request: request)
        return try await networkClient.fetch(requestCofig, with: JSONResponseHandler())
    }
    
    func fetchForecast(for location: UserLocation) async throws -> ForecastResponse {
        let request = try WeatherAPI
            .getForecast(location)
            .makeRequest()
        let requestConfig = RequestConfig(request: request)
        return try await networkClient.fetch(requestConfig, with: JSONResponseHandler())
    }
}
