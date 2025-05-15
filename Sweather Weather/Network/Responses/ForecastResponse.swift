//
//  ForecastResponse.swift
//  Sweather Weather
//
//  Created by Dima Zhiltsov on 15.05.2025.
//

import Foundation

// MARK: - Forecast Response
struct ForecastResponse: Codable {
    let location: LocationResponse
    let current: CurrentWeatherResponse
    let forecast: ForecastDataResponse
}

// MARK: - Location Response
struct LocationResponse: Codable {
    let name: String
}

// MARK: - Current Weather Response
struct CurrentWeatherResponse: Codable {
    let tempC: Double
    let condition: ConditionResponse
    
    enum CodingKeys: String, CodingKey {
        case tempC = "temp_c"
        case condition
    }
}

// MARK: - Condition Response
struct ConditionResponse: Codable {
    let text: String
    let icon: String
    let code: Int
}

// MARK: - Forecast Data Response
struct ForecastDataResponse: Codable {
    let forecastday: [ForecastDay]
    
    struct ForecastDay: Codable {
        let date: String
        let day: Day
        let hour: [Hour]
    }
    
    struct Day: Codable {
        let maxTempC: Double
        let minTempC: Double
        let condition: ConditionResponse
        
        enum CodingKeys: String, CodingKey {
            case maxTempC = "maxtemp_c"
            case minTempC = "mintemp_c"
            case condition
        }
    }
    
    struct Hour: Codable {
        let time: String
        let tempC: Double
        let condition: ConditionResponse
        
        enum CodingKeys: String, CodingKey {
            case time
            case tempC = "temp_c"
            case condition
        }
    }
}
