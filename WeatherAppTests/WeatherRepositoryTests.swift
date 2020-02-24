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

class WeatherRepositoryTests<Store: AbstractStore>: XCTestCase where Store.Entity == Weather {
    var weatherService: WeatherServiceType!
    fileprivate var weatherStore: Store!
    var weatherRepository: WeatherRepositoryType!

    override func setUp() {
        super.setUp()
        weatherService = MockWeatherService()
        weatherStore = MockWeatherStore() as? Store
        weatherRepository = WeatherRepository(weatherStore: weatherStore, weatherService: weatherService)
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
        XCTAssert(localWeathers[0].count == 2, "Expected to get 2 local wearthers back, but got \(localWeathers[0].count) back.")
    }

    func testFetchMostRecentWeather() {
        let mostRecentWeatherSequence = try! weatherRepository.fetchMostRecentWeather(skipLocal: false)
            .toBlocking()
            .toArray()

        XCTAssert(mostRecentWeatherSequence.count == 2, "Expected to get 1 local weather and 1 remote wearther back, but got \(mostRecentWeatherSequence.count) back.")
        XCTAssert(mostRecentWeatherSequence[0] == TestDataSet.localWeatherLondon, "Expected the first element to be the local london")
        XCTAssert(mostRecentWeatherSequence[1] == TestDataSet.remoteWeatherLondon, "Expected the second element to be the remote london")
    }

    func testFetchWeatherById() {
        var localWeathers = try! weatherRepository.fetchAllLocalWeathers()
            .toBlocking()
            .toArray()
        XCTAssert(localWeathers[0].count == 2, "Expected to get 2 local wearthers back, but got \(localWeathers[0].count) back.")

        // fetch weather does exist in local db
        let weatherSequence = try! weatherRepository.fetchWeather(byId: 2643743, startWithLocalCopy: true)
            .toBlocking()
            .toArray()

        XCTAssert(weatherSequence.count == 2, "Expected to get 1 local weather and 1 remote wearther back, but got \(weatherSequence.count) back.")

        XCTAssert(weatherSequence[0].dateTime! < weatherSequence[1].dateTime!, "Expected to the remote wearther has large datetime than the local one")

        localWeathers = try! weatherRepository.fetchAllLocalWeathers()
            .toBlocking()
            .toArray()
        XCTAssert(localWeathers[0].count == 2, "Expected to get 2 local wearthers back, but got \(localWeathers[0].count) back.")
    }
}

private struct MockWeatherService: WeatherServiceType {
    func fetchWeather(byCityName name: String) -> Single<Weather> {
        return Single.just(TestDataSet.remoteWeatherMountainView)
    }

    func fetchWeather(byZip zip: String, countryCode: String) -> Single<Weather> {
        return Single.just(TestDataSet.remoteWeatherMountainView)
    }

    func fetchWeather(byLatitude latitude: Double, longitude: Double) -> Single<Weather> {
        return Single.just(TestDataSet.remoteWeatherMountainView)
    }

    func fetchWeather(byId id: Int) -> Single<Weather> {
        return Single.just(TestDataSet.remoteWeatherLondon)
    }
}

private class MockWeatherStore: AbstractStore {
    private var dict = [
        TestDataSet.localWeatherLondon.id : TestDataSet.localWeatherLondon,
        TestDataSet.localWeatherShuzenji.id: TestDataSet.localWeatherShuzenji
    ]

    func fetchMostRecentEntity() -> Maybe<Weather> {
        return Maybe.just(TestDataSet.localWeatherLondon)
    }

    func fetchAll() -> Observable<[Weather]> {
        return Observable.just(Array(dict.values))
    }

    func find(by id: Int) -> Maybe<Weather> {
        if let w = dict[id] {
            return Maybe.just(w)
        } else {
            return Maybe.empty()
        }
    }

    @discardableResult
    func add(entity: Weather) -> Observable<Void> {
        dict[entity.id] = entity
        return Observable.just(())
    }

    func addOrUpdate(entity: Weather) -> Observable<Void> {
        guard let w = dict[entity.id] else {
            add(entity: entity)
            return Observable.just(())
        }
        update(entity: w)
        return Observable.just(())
    }

    @discardableResult
    func update(entity: Weather) -> Observable<Void> {
        NSLog("%@ udpated local weather with: \(entity)", #function)
        return Observable.just(())
    }

    func delete(entity: Weather) -> Observable<Void> {
        NSLog("%@ deleted weather: \(entity)", #function)
        return Observable.just(())
    }
}
