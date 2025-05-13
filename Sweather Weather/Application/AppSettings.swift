//
//  AppSettings.swift
//  Sweather Weather
//
//  Created by Dima Zhiltsov on 13.05.2025.
//

import Foundation

struct AppInfo {
    static let name = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? "Sweather Weather"
    static let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
}

enum AppBundle {
    static let test = ""
    static let production = ""

    private static let appBundle = Bundle.main.bundleIdentifier ?? production
    static var isReleaseBundle: Bool { appBundle == production }
    
    enum SharedKey {
        static let sharedSecretTest = PrivateKeys.sharedKeyTest
        static let sharedSecretProd = PrivateKeys.sharedKeyProd
    }
}
