//
//  NSObject + ext.swift
//  Sweather Weather
//
//  Created by Dima Zhiltsov on 14.05.2025.
//

import Foundation

extension NSObject {
    class var className: String {
        let array = String(describing: self).components(separatedBy: ".")
        return array.last ?? "className"
    }
}
