//
//  WeatherRequests.swift
//  WeatherApp
//
//  Created by Liyu Wang on 25/7/20.
//  Copyright © 2020 Liyu Wang. All rights reserved.
//

import Foundation

enum WeatherAPI: RequestConvertible {
    var method: HTTPMethod {
        switch self {
        case .fetchWeather:
            return .GET
        }
    }

    var path: String {
        switch self {
        case .fetchWeather:
            return "weather"
        }
    }

    var urlParameters: [String: Any]? {
        switch self {
        case .fetchWeather(let params):
            return params
        }
    }

    case fetchWeather([String: Any])
}
