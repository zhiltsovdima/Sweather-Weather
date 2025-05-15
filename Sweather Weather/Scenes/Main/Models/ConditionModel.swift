//
//  ConditionModel.swift
//  Sweather Weather
//
//  Created by Dima Zhiltsov on 15.05.2025.
//

import Foundation

struct ConditionModel {
    let text: String
    let code: Int
    
    var iconName: String {
        switch code {
        case 1000: return "sun.max"
        case 1003: return "cloud.sun"
        case 1006: return "cloud"
        case 1009: return "cloud.fill"
        case 1030: return "cloud.fog"
        case 1063, 1180, 1183, 1186, 1189, 1192, 1195: return "cloud.rain"
        case 1066, 1210, 1213, 1216, 1219, 1222, 1225: return "snowflake"
        case 1069, 1204, 1207: return "cloud.sleet"
        case 1072, 1150, 1153, 1168, 1171: return "cloud.drizzle"
        case 1087, 1273, 1276: return "cloud.bolt"
        case 1114, 1117: return "wind.snow"
        case 1135, 1147: return "fog"
        default: return "questionmark.circle"
        }
    }
            
    init(text: String, code: Int) {
        self.text = text
        self.code = code
    }
    
    init(from response: ConditionResponse) {
        self.text = response.text
        self.code = response.code
    }
}
