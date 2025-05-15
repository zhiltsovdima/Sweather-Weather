//
//  CurrentWeatherModel.swift
//  Sweather Weather
//
//  Created by Dima Zhiltsov on 15.05.2025.
//

import Foundation

struct CurrentWeatherModel {
    let city: String
    let temperature: Double
    let condition: ConditionModel
    
    var temperatureCelciusString: String {
        String(format: "%.0f°C", temperature)
    }
    
    init(city: String, temperature: Double, condition: ConditionModel) {
        self.city = city
        self.temperature = temperature
        self.condition = condition
    }
    
    init(from response: ForecastResponse) {
        self.city = response.location.name
        self.temperature = response.current.tempC
        self.condition = ConditionModel(from: response.current.condition)
    }
}
