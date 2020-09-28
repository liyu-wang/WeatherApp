//
//  WeatherStoreTests.swift
//  WeatherAppTests
//
//  Created by Liyu Wang on 2/1/20.
//  Copyright © 2020 Liyu Wang. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxBlocking
import RealmSwift
import RxRealm
@testable import WeatherApp

private extension Weather {
    static let testInstance = Weather(uid: "2643743",
                                      name: "London",
                                      country: "GB",
                                      latitude: -0.13,
                                      longitude: 51.51,
                                      dateTime: Date(timeIntervalSince1970: 1485789600),
                                      condition: "Clouds",
                                      iconStr: "04d",
                                      temperature: 9.62,
                                      tempMin: 8.33,
                                      tempMax: 11,
                                      humidity: 76,
                                      timestamp: Date())

    static let testInstance2 = Weather(uid: "1851632",
                                      name: "Shuzenji",
                                      country: "JP",
                                      latitude: 139,
                                      longitude: 35,
                                      dateTime: Date(timeIntervalSince1970: 1560350192),
                                      condition: "Clear",
                                      iconStr: "01n",
                                      temperature: 18,
                                      tempMin: 13,
                                      tempMax: 21,
                                      humidity: 80,
                                      timestamp: Date())
}

class WeatherStoreTests: XCTestCase {
    var weatherStore: RealmStore<Weather>!

    override func setUp() {
        super.setUp()
        weatherStore = RealmStore<Weather>()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
    }

    override func tearDown() {
        weatherStore = nil
        super.tearDown()
    }

    func insertTestWeathers() {
//        let weatherData1 = WeatherResponseData(id: 2643743, name: "London", dt: 1577971310, sys: WeatherResponseData.SysInfo(country: "UK"), coord: WeatherResponseData.Coordinators(lon: -0.13, lat: 51.51), weather: [WeatherResponseData.Weather(main: "Clouds", icon: "04d")], main: WeatherResponseData.MainInfo(temp: 9.62, tempMin: 8.33, tempMax: 11, humidity: 76))
        let weather1 = Weather.testInstance.asRealmModel()
        let weather2 = Weather.testInstance2.asRealmModel()
        RealmManager.write { realm in
            realm.add(weather1)
            realm.add(weather2)
        }
    }

    func testFetchAll() throws {
        insertTestWeathers()

        let allWeathers = try weatherStore.fetchAll()
            .toBlocking()
            .first()
        
        XCTAssert(allWeathers?.count == 2, "Expected to get an array of 2 weathers, but got \(String(describing: allWeathers?.count)) weather(s) back.")
    }

    func testFindById() {
        insertTestWeathers()

        let result = weatherStore.find(by: "1851632")
            .toBlocking()
            .materialize()

        switch result {
        case .completed(let elements):
            XCTAssert(elements.count == 1, "Expected to get 1 wearther observable back, but got \(elements.count) back.")
            XCTAssert(elements.first?.name == "Shuzenji", "Expected to get weather for Shuzenji back")
        case .failed(_, let error):
            XCTFail("Expected to get a weather back, but received \(error).")
        }
    }

    func testAddWeather() {
        var result = RealmManager.realm!.objects(RMWeather.self)
        XCTAssert(result.count == 0, "Expected to have 0 weather in db.")
        _ = weatherStore.add(entity: Weather.testInstance)
        result = RealmManager.realm!.objects(RMWeather.self)
        XCTAssert(result.count == 1, "Expected to have 1 weather in db.")
    }

    func testUpdateWeather() {
        _ = weatherStore.add(entity: Weather.testInstance)
        let newWeatherFromApi = Weather(uid: "2643743",
                                        name: "London",
                                        country: "GB",
                                        latitude: -0.13,
                                        longitude: 51.51,
                                        dateTime: Date(timeIntervalSince1970: 1485789600),
                                        condition: "Sunny",
                                        iconStr: "04d",
                                        temperature: 12,
                                        tempMin: 6,
                                        tempMax: 16,
                                        humidity: 90,
                                        timestamp: Date())
        _ = weatherStore.update(entity: newWeatherFromApi)
        let weatherFromDB = RealmManager.realm!.object(ofType: RMWeather.self, forPrimaryKey: "2643743")
        XCTAssert(weatherFromDB?.condition == "Sunny", "Expected the codition updated to Sunny")
    }

    func testDeleteWeather() {
        let weather = Weather.testInstance
        _ = weatherStore.add(entity: weather)
        var result = RealmManager.realm!.objects(RMWeather.self)
        XCTAssert(result.count == 1, "Expected to have 1 weather in db.")
        _ = weatherStore.delete(entity: weather)
        result = RealmManager.realm!.objects(RMWeather.self)
        XCTAssert(result.count == 0, "Expected to have 0 weather in db.")
    }
}
