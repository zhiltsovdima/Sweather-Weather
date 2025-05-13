//
//  WeatherResponse.swift
//  Sweather Weather
//
//  Created by Dima Zhiltsov on 13.05.2025.
//

import Foundation

struct CurrentWeatherResponse: Decodable {
    let cityName: String
    let temperature: Double
    let condition: String
    let humidity: Int

    enum CodingKeys: String, CodingKey {
        case location
        case current
    }

    enum LocationKeys: String, CodingKey {
        case name
    }

    enum CurrentKeys: String, CodingKey {
        case tempC = "temp_c"
        case humidity
        case condition
    }

    enum ConditionKeys: String, CodingKey {
        case text
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let locationContainer = try container.nestedContainer(keyedBy: LocationKeys.self, forKey: .location)
        cityName = try locationContainer.decode(String.self, forKey: .name)

        let currentContainer = try container.nestedContainer(keyedBy: CurrentKeys.self, forKey: .current)
        temperature = try currentContainer.decode(Double.self, forKey: .tempC)
        humidity = try currentContainer.decode(Int.self, forKey: .humidity)

        let conditionContainer = try currentContainer.nestedContainer(keyedBy: ConditionKeys.self, forKey: .condition)
        condition = try conditionContainer.decode(String.self, forKey: .text)
    }
}
