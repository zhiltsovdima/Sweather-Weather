//
//  ForecastDayModel.swift
//  Sweather Weather
//
//  Created by Dima Zhiltsov on 15.05.2025.
//

import Foundation

struct ForecastDayModel {
    let date: String
    let day: Day
    let hour: [Hour]
    
    var dayOfWeek: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: self.date) else { return "" }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
    
    init(date: String, day: Day, hour: [Hour]) {
        self.date = date
        self.day = day
        self.hour = hour
    }
    
    init(from forecast: ForecastDataResponse.ForecastDay) {
        self.date = forecast.date
        self.day = Day(from: forecast.day)
        self.hour = forecast.hour.map { Hour(from: $0) }
    }
}

extension ForecastDayModel {
    
    // MARK: - Day Model
    struct Day {
        let maxTempC: Double
        let minTempC: Double
        let condition: ConditionModel
        
        init(from day: ForecastDataResponse.Day) {
            self.maxTempC = day.maxTempC
            self.minTempC = day.minTempC
            self.condition = ConditionModel(from: day.condition)
        }
    }
    
    // MARK: - Hour Model
    struct Hour {
        let time: String
        let tempC: Double
        let condition: ConditionModel
        
        var visibleHour: String {
            let components = time.split(separator: " ")
            return components.last?.prefix(5).description ?? time
        }
        
        init(time: String, tempC: Double, condition: ConditionModel) {
            self.time = time
            self.tempC = tempC
            self.condition = condition
        }
        
        init(from hour: ForecastDataResponse.Hour) {
            self.time = hour.time
            self.tempC = hour.tempC
            self.condition = ConditionModel(from: hour.condition)
        }
    }
}
