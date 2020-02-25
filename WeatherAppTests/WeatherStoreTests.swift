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
    convenience init(id: Int, name: String, condition: String, timestamp: Date) {
        self.init()
        self.id = id
        self.name = name
        self.condition = condition
        self.timestamp = timestamp
    }
}

class WeatherStoreTests: XCTestCase {
    var weatherStore: RealmStore<Weather>!

    override func setUp() {
        super.setUp()
        weatherStore = RealmStore<Weather>()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = "testdb"
    }

    override func tearDown() {
        weatherStore = nil
        super.tearDown()
    }

    func insertTestWeathers() {
        let weatherData = WeatherServiceData(id: 2643743, name: "London", dt: 1577971310, sys: WeatherServiceData.SysInfo(country: "UK"), coord: WeatherServiceData.Coordinators(lon: -0.13, lat: 51.51), weather: [WeatherServiceData.Weather(main: "Clouds", icon: "04d")], main: WeatherServiceData.MainInfo(temp: 9.62, tempMin: 8.33, tempMax: 11, humidity: 76))
        // weather1 has timestamp -> Date()
        let weather1 = Weather(from: weatherData)
        let weather2 = Weather(id: 1851632, name: "Shuzenji", condition: "Windy", timestamp: Date().addingTimeInterval(10))
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

        let result = weatherStore.find(by: 1851632)
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
        var result = RealmManager.realm!.objects(Weather.self)
        XCTAssert(result.count == 0, "Expected to have 0 weather in db.")
        let weather = Weather(id: 2643743, name: "London", condition: "Clouds", timestamp: Date())
        _ = weatherStore.add(entity: weather)
        result = RealmManager.realm!.objects(Weather.self)
        XCTAssert(result.count == 1, "Expected to have 1 weather in db.")
    }

    func testUpdateWeather() {
        let weather = Weather(id: 2643743, name: "London", condition: "Clouds", timestamp: Date())
        _ = weatherStore.add(entity: weather)
        let newWeatherFromApi = Weather(id: 2643743, name: "London", condition: "Sunny", timestamp: Date())
        _ = weatherStore.update(entity: newWeatherFromApi)
        let weatherFromDB = RealmManager.realm!.object(ofType: Weather.self, forPrimaryKey: 2643743)
        XCTAssert(weatherFromDB?.condition == "Sunny", "Expected the codition updated to Sunny")
    }

    func testDeleteWeather() {
        let weather = Weather(id: 2643743, name: "London", condition: "Clouds", timestamp: Date())
        _ = weatherStore.add(entity: weather)
        var result = RealmManager.realm!.objects(Weather.self)
        XCTAssert(result.count == 1, "Expected to have 1 weather in db.")
        _ = weatherStore.delete(entity: weather)
        result = RealmManager.realm!.objects(Weather.self)
        XCTAssert(result.count == 0, "Expected to have 0 weather in db.")
    }
}
