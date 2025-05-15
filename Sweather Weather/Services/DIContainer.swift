//
//  DIContainer.swift
//  Sweather Weather
//
//  Created by Dima Zhiltsov on 13.05.2025.
//

import Foundation

// Чтобы не усложнять тестовое задание, был использован такой простой сервис локатор, который хранит в себе все нужные сервисы
// Если все же усложнять, то можно воспользоваться Swinject или написать свое решение более грамотное
class DIContainer {
    static let shared = DIContainer()
    
    private init() {}
    
    private let networkProvider: NetworkProvider = URLSessionProvider()
    private lazy var networkClient: NetworkClient = DefaultNetworkClient(provider: networkProvider)
    
    lazy var weatherService: WeatherService = WeatherServiceImpl(networkClient: networkClient)
    let locationService: LocationService = LocationServiceImpl()
    let alertsFactory: AlertFactoryProtocol = AlertFactory()
}
