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
    var weatherRepository: WeatherRepositoryType!

    override func setUp() {
        super.setUp()
        weatherRepository = WeatherRepository(weatherService: MockWeatherService(), weatherStore: MockWeatherStore())
    }

    override func tearDown() {
        weatherRepository = nil
        super.tearDown()
    }

    func testFetchWeatherByName() {
        XCTFail("not implemented.")
    }

    func testFetchWeatherByZip() {
        XCTFail("not implemented.")
    }

    func testFetchWeatherByCoordinates() {
        XCTFail("not implemented.")
    }

    func testFetchAll() {
        XCTFail("not implemented.")
    }

    func testFetchMostRecent() {
        XCTFail("not implemented.")
    }
}

private struct MockWeatherService: WeatherServiceType {
    func fetchWeather(byCityName name: String) -> Observable<Weather> {
        return Observable.just(Weather())
    }

    func fetchWeather(byZip zip: String, countryCode: String) -> Observable<Weather> {
        return Observable.just(Weather())
    }

    func fetchWeather(byLatitude latitude: Double, longitude: Double) -> Observable<Weather> {
        return Observable.just(Weather())
    }

    func fetchWeather(byId id: Int) -> Observable<Weather> {
        return Observable.just(Weather())
    }
}

private struct MockWeatherStore: WeatherStoreType {
    func fetchAll() -> Observable<[Weather]> {
        return Observable.just([])
    }

    func fetchMostRecent() -> Observable<Weather?> {
        return Observable.just(nil)
    }

    func add(weather: Weather) {

    }

    func update(weather: Weather) {

    }

    func delete(weather: Weather) {

    }
}
