//
//  WeatherService.swift
//  Sweather Weather
//
//  Created by Dima Zhiltsov on 13.05.2025.
//

import Foundation

protocol WeatherService: AnyObject {
    func getCurrentWeather(for location: UserLocation) async throws -> CurrentWeatherResponse
}

final class WeatherServiceImpl: WeatherService {
    
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func getCurrentWeather(for location: UserLocation) async throws -> CurrentWeatherResponse {
        let request = try WeatherAPI
            .getCurrent(location)
            .makeRequest()
        let requestCofig = RequestConfig(request: request)
        return try await networkClient.fetch(requestCofig, with: JSONResponseHandler())
    }
}
