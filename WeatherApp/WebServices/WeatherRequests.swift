//
//  WeatherRequests.swift
//  WeatherApp
//
//  Created by Liyu Wang on 25/7/20.
//  Copyright © 2020 Liyu Wang. All rights reserved.
//

import Foundation

enum WeatherRequest: RequestRepresentable {
    var method: HTTPMethod {
        switch self {
        case .fetchWeatherByName,
             .fetchWeatherByZip,
             .fetchWeatherByCoordinates,
             .fetchWeatherById:
            return .GET
        }
    }

    var path: String {
        switch self {
        case .fetchWeatherByName,
             .fetchWeatherByZip,
             .fetchWeatherByCoordinates,
             .fetchWeatherById:
            return "weather"
        }
    }

    var urlParameters: URLParametersRepresentable? {
        switch self {
        case .fetchWeatherByName(let params):
            return params
        case .fetchWeatherByZip(let params):
            return params
        case .fetchWeatherByCoordinates(let params):
            return params
        case .fetchWeatherById(let params):
            return params
        }
    }

    case fetchWeatherByName(FetchWeatherByCityNameRequest)
    case fetchWeatherByZip(FetchWeatherByZipRequest)
    case fetchWeatherByCoordinates(FetchWeatherByCoordinatesRequest)
    case fetchWeatherById(FetchWeatherByIdRequest)
}

struct FetchWeatherByCityNameRequest: URLParametersRepresentable {
    let q: String
}

struct FetchWeatherByZipRequest: URLParametersRepresentable {
    let zip: String
}

struct FetchWeatherByCoordinatesRequest: URLParametersRepresentable {
    let lat: Double
    let lon: Double
}

struct FetchWeatherByIdRequest: URLParametersRepresentable {
    let id: Int
}
