//
//  WeatherListViewModelTests.swift
//  WeatherAppTests
//
//  Created by Liyu Wang on 4/1/20.
//  Copyright © 2020 Liyu Wang. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
@testable import WeatherApp

class WeatherListViewModelTests: XCTestCase {
    private var bag: DisposeBag!
    private var scheduler: TestScheduler!
    var viewModel: WeatherListViewModel!

    override func setUp() {
        viewModel = WeatherListViewModel(repository: MockWeatherRepository())
        bag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
        super.setUp()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testFetchAllLocalWeathers() {
        let weathersObserver = scheduler.createObserver([Weather].self)
        viewModel.weatherListObservable
            .subscribe(weathersObserver)
            .disposed(by: bag)
        scheduler.start()

        // fetchAllLocalWeathers() get called in WeatherListViewModel's init

        XCTAssertRecordedElements(weathersObserver.events, [[
            TestDataSet.localWeatherLondon,
            TestDataSet.localWeatherShuzenji
        ]])
    }

    func testDeleteWeather() {
        let weathersObserver = scheduler.createObserver([Weather].self)
        viewModel.weatherListObservable
            .subscribe(weathersObserver)
            .disposed(by: bag)
        scheduler.start()

        viewModel.delete(weather: TestDataSet.localWeatherShuzenji)

        XCTAssertRecordedElements(weathersObserver.events, [
            [TestDataSet.localWeatherLondon, TestDataSet.localWeatherShuzenji],
            [TestDataSet.localWeatherLondon]
        ])
    }
}
