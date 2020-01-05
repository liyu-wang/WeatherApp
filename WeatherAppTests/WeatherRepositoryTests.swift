//
//  WeatherRepositoryTests.swift
//  WeatherAppTests
//
//  Created by Wang, Liyu on 3/1/20.
//  Copyright © 2020 Liyu Wang. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxBlocking
import RealmSwift
import RxRealm
@testable import WeatherApp

class WeatherRepositoryTests: XCTestCase {
    var weatherService: WeatherServiceType!
    var weatherStore: WeatherStoreType!
    var weatherRepository: WeatherRepositoryType!

    override func setUp() {
        super.setUp()
        weatherService = MockWeatherService()
        weatherStore = MockWeatherStore()
        weatherRepository = WeatherRepository(weatherService: weatherService, weatherStore: weatherStore)
    }

    override func tearDown() {
        weatherRepository = nil
        super.tearDown()
    }

    func testFetchWeatherByName() {
        // fetch weather does not exist in local db
        let result = try! weatherRepository.fetchWeather(byCityName: "Mountain View")
            .toBlocking()
            .toArray()
        XCTAssert(result.count == 1, "Expected to get 1 remote wearther back, but got \(result.count) back.")

        let localWeathers = try!weatherRepository.fetchAllLocalWeathers()
            .toBlocking()
            .toArray()
        XCTAssert(localWeathers[0].count == 3, "Expected to get 3 local wearthers back, but got \(localWeathers[0].count) back.")
    }

    func testFetchWeatherByZip() {
        // fetch weather does not exist in local db
        let result = try! weatherRepository.fetchWeather(byZip: "94035", countryCode: "US")
            .toBlocking()
            .toArray()
        XCTAssert(result.count == 1, "Expected to get 1 remote wearther back, but got \(result.count) back.")

        let localWeathers = try!weatherRepository.fetchAllLocalWeathers()
            .toBlocking()
            .toArray()
        XCTAssert(localWeathers[0].count == 3, "Expected to get 3 local wearthers back, but got \(localWeathers[0].count) back.")
    }

    func testFetchWeatherByCoordinates() {
        // fetch weather does not exist in local db
        let result = try! weatherRepository.fetchWeather(byLatitude: -122.08, longitude: 37.39)
            .toBlocking()
            .toArray()
        XCTAssert(result.count == 1, "Expected to get 1 remote wearther back, but got \(result.count) back.")

        let localWeathers = try!weatherRepository.fetchAllLocalWeathers()
            .toBlocking()
            .toArray()
        XCTAssert(localWeathers[0].count == 3, "Expected to get 3 local wearthers back, but got \(localWeathers[0].count) back.")
    }

    func testFetchAllLocalWeathers() {
        let localWeathers = try!weatherRepository.fetchAllLocalWeathers()
            .toBlocking()
            .toArray()
        XCTAssert(localWeathers[0].count == 2, "Expected to get 3 local wearthers back, but got \(localWeathers[0].count) back.")
    }

    func testFetchWeatherById() {
        var localWeathers = try!weatherRepository.fetchAllLocalWeathers()
            .toBlocking()
            .toArray()
        XCTAssert(localWeathers[0].count == 2, "Expected to get 2 local wearthers back, but got \(localWeathers[0].count) back.")

        // fetch weather does exist in local db
        let weatherSequence = try!weatherRepository.fetchWeather(byId: 2643743)
            .toBlocking()
            .toArray()

        XCTAssert(weatherSequence.count == 2, "Expected to get 1 local weather and 1 remote wearther back, but got \(weatherSequence.count) back.")

        XCTAssert(weatherSequence[0].dateTime! < weatherSequence[1].dateTime!, "Expected to the remote wearther has large datetime than the local one")

        localWeathers = try!weatherRepository.fetchAllLocalWeathers()
            .toBlocking()
            .toArray()
        XCTAssert(localWeathers[0].count == 2, "Expected to get 2 local wearthers back, but got \(localWeathers[0].count) back.")
    }
}

private struct TestDataSet {
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

private struct MockWeatherService: WeatherServiceType {
    func fetchWeather(byCityName name: String) -> Observable<Weather> {
        return Observable.just(TestDataSet.remoteWeatherMountainView)
    }

    func fetchWeather(byZip zip: String, countryCode: String) -> Observable<Weather> {
        return Observable.just(TestDataSet.remoteWeatherMountainView)
    }

    func fetchWeather(byLatitude latitude: Double, longitude: Double) -> Observable<Weather> {
        return Observable.just(TestDataSet.remoteWeatherMountainView)
    }

    func fetchWeather(byId id: Int) -> Observable<Weather> {
        return Observable.just(TestDataSet.remoteWeatherLondon)
    }
}

private class MockWeatherStore: WeatherStoreType {
    private var dict = [
        TestDataSet.localWeatherLondon.id : TestDataSet.localWeatherLondon,
        TestDataSet.localWeatherShuzenji.id: TestDataSet.localWeatherShuzenji
    ]

    func fetchAll() -> Observable<[Weather]> {
        return Observable.just(Array(dict.values))
    }

    func find(by id: Int) -> Observable<Weather> {
        guard let w = dict[id] else {
            return Observable.error(WeatherStoreError.weatherWithSpecifiedIdNotExist(id: id))
        }
        return Observable.just(w)
    }

    @discardableResult
    func add(weather: Weather) -> Observable<Void> {
        dict[weather.id] = weather
        return Observable.just(())
    }

    func addOrUpdate(weather: Weather) -> Observable<Void> {
        guard let w = dict[weather.id] else {
            add(weather: weather)
            return Observable.just(())
        }
        update(weather: w)
        return Observable.just(())
    }

    @discardableResult
    func update(weather: Weather) -> Observable<Void> {
        NSLog("%@ udpated local weather with: \(weather)", #function)
        return Observable.just(())
    }

    func delete(weather: Weather) -> Observable<Void> {
        NSLog("%@ deleted weather: \(weather)", #function)
        return Observable.just(())
    }
}
