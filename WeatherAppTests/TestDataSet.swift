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
    static var localWeatherLondon: Weather {
        let weatherData = WeatherResponseData(id: 2643743, name: "London", dt: 1577971310, sys: WeatherResponseData.SysInfo(country: "UK"), coord: WeatherResponseData.Coordinators(lon: -0.13, lat: 51.51), weather: [WeatherResponseData.Weather(main: "Clouds", icon: "04d")], main: WeatherResponseData.MainInfo(temp: 9.62, tempMin: 8.33, tempMax: 11, humidity: 76))
        return Weather(from: weatherData)
    }
    static var localWeatherShuzenji: Weather {
        let weatherData = WeatherResponseData(id: 1851632, name: "Shuzenji", dt: 1560350192, sys: WeatherResponseData.SysInfo(country: "JP"), coord: WeatherResponseData.Coordinators(lon: 139, lat: 35), weather: [WeatherResponseData.Weather(main: "clear sky", icon: "01n")], main: WeatherResponseData.MainInfo(temp: 20, tempMin: 15, tempMax: 23, humidity: 70))
        return Weather(from: weatherData)
    }

    static var remoteWeatherLondon: Weather {
        let weatherData = WeatherResponseData(id: 2643743, name: "London", dt: 1577978888, sys: WeatherResponseData.SysInfo(country: "UK"), coord: WeatherResponseData.Coordinators(lon: -0.13, lat: 51.51), weather: [WeatherResponseData.Weather(main: "few clouds", icon: "02d")], main: WeatherResponseData.MainInfo(temp: 13, tempMin: 10, tempMax: 15, humidity: 65))
        return Weather(from: weatherData)
    }
    static var remoteWeatherMountainView: Weather {
        let weatherData = WeatherResponseData(id: 420006353, name: "Mountain View", dt: 1560350645, sys: WeatherResponseData.SysInfo(country: "US"), coord: WeatherResponseData.Coordinators(lon: -122.08, lat: 37.39), weather: [WeatherResponseData.Weather(main: "clear sky", icon: "01d")], main: WeatherResponseData.MainInfo(temp: 23, tempMin: 13, tempMax: 26, humidity: 66))
        return Weather(from: weatherData)
    }
}
