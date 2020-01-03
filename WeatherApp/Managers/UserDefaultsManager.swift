//
//  UserDefaultsManager.swift
//  WeatherApp
//
//  Created by Liyu Wang on 4/1/20.
//  Copyright © 2020 Liyu Wang. All rights reserved.
//

import Foundation

private struct Constants {
    static let key = "most-recent-weather-id"
}

struct UserDefaultsManager {
    static func saveMostRecentWeahter(id: Int) {
        let defaults = UserDefaults.standard
        defaults.set(id, forKey: Constants.key)
    }

    static func loadMostRecentWeatherId() -> Int? {
        let defaults = UserDefaults.standard
        let id = defaults.integer(forKey: Constants.key)
        return id == 0 ? nil : id
    }
}
