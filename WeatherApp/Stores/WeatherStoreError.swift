//
//  WeatherStoreError.swift
//  WeatherApp
//
//  Created by Wang, Liyu on 3/1/20.
//  Copyright © 2020 Liyu Wang. All rights reserved.
//

import Foundation

enum WeatherStoreError: Error {
    case failedToInitDBInstance
    case weatherWithSpecifiedIdNotExist(id: Int)
}

extension WeatherStoreError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .failedToInitDBInstance:
            return "Failed to init db instance."
        case .weatherWithSpecifiedIdNotExist(let id):
            return "Weather[\(id)] doesn't exist."
        }
    }
}
