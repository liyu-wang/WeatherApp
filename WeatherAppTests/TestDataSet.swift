//
//  TestDataSet.swift
//  WeatherAppTests
//
//  Created by Liyu Wang on 5/1/20.
//  Copyright © 2020 Liyu Wang. All rights reserved.
//

import Foundation
@testable import WeatherApp

struct TestDataSet {
    static let localWeatherLondon: Weather = {
        let weatherData = WeatherServiceData(id: 2643743, name: "London", dt: 1577971310, sys: WeatherServiceData.SysInfo(country: "UK"), coord: WeatherServiceData.Coordinators(lon: -0.13, lat: 51.51), weather: [WeatherServiceData.Weather(main: "Clouds", icon: "04d")], main: WeatherServiceData.MainInfo(temp: 9.62, tempMin: 8.33, tempMax: 11, humidity: 76))
        return Weather(from: weatherData)
    }()
    static let localWeatherShuzenji: Weather = {
        let weatherData = WeatherServiceData(id: 1851632, name: "Shuzenji", dt: 1560350192, sys: WeatherServiceData.SysInfo(country: "JP"), coord: WeatherServiceData.Coordinators(lon: 139, lat: 35), weather: [WeatherServiceData.Weather(main: "clear sky", icon: "01n")], main: WeatherServiceData.MainInfo(temp: 20, tempMin: 15, tempMax: 23, humidity: 70))
        return Weather(from: weatherData)
    }()

    static let remoteWeatherLondon: Weather = {
        let weatherData = WeatherServiceData(id: 2643743, name: "London", dt: 1577978888, sys: WeatherServiceData.SysInfo(country: "UK"), coord: WeatherServiceData.Coordinators(lon: -0.13, lat: 51.51), weather: [WeatherServiceData.Weather(main: "few clouds", icon: "02d")], main: WeatherServiceData.MainInfo(temp: 13, tempMin: 10, tempMax: 15, humidity: 65))
        return Weather(from: weatherData)
    }()
    static let remoteWeatherMountainView: Weather = {
        let weatherData = WeatherServiceData(id: 420006353, name: "Mountain View", dt: 1560350645, sys: WeatherServiceData.SysInfo(country: "US"), coord: WeatherServiceData.Coordinators(lon: -122.08, lat: 37.39), weather: [WeatherServiceData.Weather(main: "clear sky", icon: "01d")], main: WeatherServiceData.MainInfo(temp: 23, tempMin: 13, tempMax: 26, humidity: 66))
        return Weather(from: weatherData)
    }()
}
