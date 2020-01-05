//
//  WeatherViewModelTests.swift
//  WeatherAppTests
//
//  Created by Liyu Wang on 31/12/19.
//  Copyright © 2019 Liyu Wang. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
@testable import WeatherApp

class WeatherViewModelTests: XCTestCase {
    private var bag: DisposeBag!
    private var scheduler: TestScheduler!
    private var viewModel: WeatherViewModel!

    override func setUp() {
        bag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
        super.setUp()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testFetchWeatherByName() {
        viewModel = WeatherViewModel(
            repository: MockWeatherRepository(),
            userDefaultsManager: MockUserDefaultsManager()
        )

        let weatherObserver = scheduler.createObserver(Weather?.self)
        viewModel.weatherDrive
            .drive(weatherObserver)
            .disposed(by: bag)
        scheduler.start()

        viewModel.fetchWeather(byCityName: "London")

        XCTAssertRecordedElements(weatherObserver.events, [nil, TestDataSet.remoteWeatherLondon])
    }

    func testFetchWeatherByZip() {
        viewModel = WeatherViewModel(
            repository: MockWeatherRepository(),
            userDefaultsManager: MockUserDefaultsManager()
        )

        let weatherObserver = scheduler.createObserver(Weather?.self)
        viewModel.weatherDrive
            .drive(weatherObserver)
            .disposed(by: bag)
        scheduler.start()

        viewModel.fetchWeather(byZip: "CA91016", country: "UK")

        XCTAssertRecordedElements(weatherObserver.events, [nil, TestDataSet.remoteWeatherLondon])
    }

    func testMostRecentWeather() {
        viewModel = WeatherViewModel(
            repository: MockWeatherRepository(),
            userDefaultsManager: MockUserDefaultsManager(mostRecentWeatherId: TestDataSet.localWeatherLondon.id)
        )

        let weatherObserver = scheduler.createObserver(Weather?.self)
        viewModel.weatherDrive
            .drive(weatherObserver)
            .disposed(by: bag)
        scheduler.start()

        viewModel.fetchMostRecentWeather()

        XCTAssertRecordedElements(weatherObserver.events, [nil, TestDataSet.localWeatherLondon, TestDataSet.remoteWeatherLondon])
    }
}

private class MockUserDefaultsManager: UserDefaultsManagerType {
    private let mostRecentWeatherId: Int?

    init(mostRecentWeatherId: Int? = nil) {
        self.mostRecentWeatherId = mostRecentWeatherId
    }

    func saveMostRecentWeahter(id: Int) {
    }

    func loadMostRecentWeatherId() -> Int? {
        return mostRecentWeatherId
    }
}
