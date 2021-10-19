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
import RxTest
import RealmSwift
import RxRealm
@testable import WeatherApp

class WeatherRepositoryTests: XCTestCase {
    var bag: DisposeBag!
    var testScheduler: TestScheduler!
    var weatherService: WeatherWebServiceType!
    var weatherStore: RealmStore<Weather>!
    var weatherRepository: WeatherRepositoryType!

    override func setUp() {
        super.setUp()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        bag = DisposeBag()
        testScheduler = TestScheduler(initialClock: 0)
        weatherService = MockWeatherService()
        weatherStore = RealmStore<Weather>()
        weatherRepository = WeatherRepository(weatherStore: weatherStore, weatherService: weatherService)
        prepareDB()
    }

    override func tearDown() {
        bag = nil
        testScheduler = nil
        weatherRepository = nil
        weatherStore = nil
        weatherService = nil
        super.tearDown()
    }

    private func prepareDB() {
        RealmManager.write { realm in
            realm.add(TestDataSet.localWeatherShuzenji.asRealmModel())
            realm.add(TestDataSet.localWeatherLondon.asRealmModel())
        }
    }

    func testFetchWeatherByName() {
        let weathersObserver = testScheduler.createObserver([Weather].self)
        weatherRepository.fetchAllLocalWeathers() // by default sort by timestamp, descending
            .observeOn(SerialDispatchQueueScheduler.init(qos: .userInitiated))
            .bind(to: weathersObserver)
            .disposed(by: bag)
        testScheduler.start()

        // fetch weather does not exist in local db
        let result = try! weatherRepository.fetchWeather(byCityName: "Mountain View")
            .toBlocking()
            .toArray()
        XCTAssert(result.count == 1, "Expected to get 1 remote weather back, but got \(result.count) back.")

        Thread.sleep(forTimeInterval: 1)

        XCTAssertRecordedElements(weathersObserver.events, [
            [
                TestDataSet.localWeatherLondon,
                TestDataSet.localWeatherShuzenji
            ],
            [
                TestDataSet.remoteWeatherMountainView,
                TestDataSet.localWeatherLondon,
                TestDataSet.localWeatherShuzenji
            ]
        ])
    }

    func testFetchWeatherByZip() {
        let weathersObserver = testScheduler.createObserver([Weather].self)
        weatherRepository.fetchAllLocalWeathers() // by default sort by timestamp, descending
            .observeOn(SerialDispatchQueueScheduler.init(qos: .userInitiated))
            .bind(to: weathersObserver)
            .disposed(by: bag)
        testScheduler.start()

        // fetch weather does not exist in local db
        let result = try! weatherRepository.fetchWeather(byZip: "94035", countryCode: "US")
            .toBlocking()
            .toArray()
        XCTAssert(result.count == 1, "Expected to get 1 remote weather back, but got \(result.count) back.")

        Thread.sleep(forTimeInterval: 1)

        XCTAssertRecordedElements(weathersObserver.events, [
            [
                TestDataSet.localWeatherLondon,
                TestDataSet.localWeatherShuzenji
            ],
            [
                TestDataSet.remoteWeatherMountainView,
                TestDataSet.localWeatherLondon,
                TestDataSet.localWeatherShuzenji
            ]
        ])
    }

    func testFetchAllLocalWeathers() {
        let weathersObserver = testScheduler.createObserver([Weather].self)
        weatherRepository.fetchAllLocalWeathers() // by default sort by timestamp, descending
            .observeOn(SerialDispatchQueueScheduler.init(qos: .userInitiated))
            .bind(to: weathersObserver)
            .disposed(by: bag)
        testScheduler.start()

        Thread.sleep(forTimeInterval: 1)

        XCTAssertRecordedElements(weathersObserver.events, [
            [
                TestDataSet.localWeatherLondon,
                TestDataSet.localWeatherShuzenji
            ]
        ])
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
        let weathersObserver = testScheduler.createObserver([Weather].self)
        weatherRepository.fetchAllLocalWeathers() // by default sort by timestamp, descending
            .observeOn(SerialDispatchQueueScheduler.init(qos: .userInitiated))
            .bind(to: weathersObserver)
            .disposed(by: bag)
        testScheduler.start()

        // fetch weather does exist in local db
        let weatherSequence = try! weatherRepository.fetchWeather(byId: "2643743", startWithLocalCopy: true)
            .toBlocking()
            .toArray()

        XCTAssert(weatherSequence.count == 2, "Expected to get 1 local weather and 1 remote weather back, but got \(weatherSequence.count) back.")

        XCTAssert(weatherSequence[0].dateTime! < weatherSequence[1].dateTime!, "Expected to the remote weather has large datetime than the local one")

        Thread.sleep(forTimeInterval: 1)

        // the new remote weather should override the old local weather in the db
        XCTAssertRecordedElements(weathersObserver.events, [
            [
                TestDataSet.localWeatherLondon,
                TestDataSet.localWeatherShuzenji
            ],
            [
                TestDataSet.remoteWeatherLondon,
                TestDataSet.localWeatherShuzenji
            ]
        ])
    }
}

private struct MockWeatherService: WeatherWebServiceType {
    func fetchWeather(byCityName name: String) -> Single<Weather> {
        return Single.just(TestDataSet.remoteWeatherMountainView)
    }

    func fetchWeather(byZip zip: String, countryCode: String) -> Single<Weather> {
        return Single.just(TestDataSet.remoteWeatherMountainView)
    }

    func fetchWeather(byLatitude latitude: Double, longitude: Double) -> Single<Weather> {
        return Single.just(TestDataSet.remoteWeatherMountainView)
    }

    func fetchWeather(byId id: String) -> Single<Weather> {
        return Single.just(TestDataSet.remoteWeatherLondon)
    }
}

/*
private class MockWeatherStore: AbstractStore {
    private var dict = [
        TestDataSet.localWeatherLondon.uid : TestDataSet.localWeatherLondon,
        TestDataSet.localWeatherShuzenji.uid: TestDataSet.localWeatherShuzenji
    ]

    func fetchMostRecentEntity(sortKey: SortKey?) -> Maybe<Weather> {
        return Maybe.just(TestDataSet.localWeatherLondon)
    }

    func fetchAll(sortKey: SortKey?) -> Observable<[Weather]> {
        return Observable.just(Array(dict.values))
    }

    func find(by id: String) -> Maybe<Weather> {
        if let w = dict[id] {
            return Maybe.just(w)
        } else {
            return Maybe.empty()
        }
    }

    @discardableResult
    func add(entity: Weather) -> Observable<Void> {
        dict[entity.uid] = entity
        return Observable.just(())
    }

    func addOrUpdate(entity: Weather) -> Observable<Void> {
        guard let w = dict[entity.uid] else {
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
*/
