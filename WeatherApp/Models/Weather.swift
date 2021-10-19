//
//  Weather.swift
//  WeatherApp
//
//  Created by Liyu Wang on 23/8/20.
//  Copyright © 2020 Liyu Wang. All rights reserved.
//

import Foundation

struct Weather {
    var uid: String
    var name: String
    var country: String
    var latitude: Double
    var longitude: Double
    var dateTime: Date?
    var condition: String
    var iconStr: String
    var temperature: Float
    var tempMin: Float
    var tempMax: Float
    var humidity: Int
    var timestamp: Date?
}

extension Weather {
    var iconURL: URL? {
        let urlStr = String(format: WebServiceConstants.iconURL, iconStr)
        return URL(string: urlStr)
    }
}

extension Weather: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.uid == rhs.uid
    }
}

extension Weather: SortableByTime {
    static let timeSortKey = SortKey(keyPath: "timestamp", ascending: false)
}

extension Weather {
    init(from weatherServiceData: WeatherResponseData) {
        uid = "\(weatherServiceData.id)"
        name = weatherServiceData.name
        country = weatherServiceData.sys.country
        latitude = weatherServiceData.coord.lat
        longitude = weatherServiceData.coord.lon
        dateTime = Date(timeIntervalSince1970: TimeInterval(weatherServiceData.dt))
        condition = weatherServiceData.weather.first?.main ?? ""
        iconStr = weatherServiceData.weather.first?.icon ?? ""
        temperature = weatherServiceData.main.temp
        tempMin = weatherServiceData.main.tempMin
        tempMax = weatherServiceData.main.tempMax
        humidity = weatherServiceData.main.humidity
        timestamp = Date()
    }
}

extension Weather {
    static let emptyWeather: Weather = {
        let weatherData = WeatherResponseData(id: 0, name: "City Name", dt: 1577971310, sys: WeatherResponseData.SysInfo(country: "Country"), coord: WeatherResponseData.Coordinators(lon: 0, lat: 0), weather: [WeatherResponseData.Weather(main: "N/A", icon: "04d")], main: WeatherResponseData.MainInfo(temp: 0, tempMin: 0, tempMax: 0, humidity: 0))
        return Weather(from: weatherData)
    }()
}
