//
//  UserLocation.swift
//  Sweather Weather
//
//  Created by Dima Zhiltsov on 13.05.2025.
//

import Foundation

struct UserLocation {
    let latitude: Double
    let longitude: Double
    
    var requestForm: String {
        return "\(latitude)" + "," + "\(longitude)"
    }
}

extension UserLocation {
    /// Moscow by default
    static let defaultLocation: UserLocation = .init(latitude: 55.751244, longitude: 37.618423)
}
