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
        viewModel = WeatherViewModel(repository: MockWeatherRepository())

        let weatherObserver = scheduler.createObserver(Weather?.self)
        viewModel.weatherDriver
            .drive(weatherObserver)
            .disposed(by: bag)
        scheduler.start()

        viewModel.fetchWeather(byCityName: "London")

        XCTAssertRecordedElements(weatherObserver.events, [Weather.emptyWeather, TestDataSet.remoteWeatherLondon])
    }

    func testFetchWeatherByZip() {
        viewModel = WeatherViewModel(repository: MockWeatherRepository())

        let weatherObserver = scheduler.createObserver(Weather?.self)
        viewModel.weatherDriver
            .drive(weatherObserver)
            .disposed(by: bag)
        scheduler.start()

        viewModel.fetchWeather(byZip: "CA91016", country: "UK")

        XCTAssertRecordedElements(weatherObserver.events, [Weather.emptyWeather, TestDataSet.remoteWeatherLondon])
    }

    func testMostRecentWeather() {
        viewModel = WeatherViewModel(repository: MockWeatherRepository())

        let weatherObserver = scheduler.createObserver(Weather?.self)
        viewModel.weatherDriver
            .drive(weatherObserver)
            .disposed(by: bag)
        scheduler.start()

        viewModel.fetchMostRecentWeather(skipLocal: false)

        XCTAssertRecordedElements(weatherObserver.events, [Weather.emptyWeather, TestDataSet.localWeatherLondon, TestDataSet.remoteWeatherLondon])
    }
}
