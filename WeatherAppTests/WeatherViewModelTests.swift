//
//  WeatherViewModelTests.swift
//  WeatherAppTests
//
//  Created by Liyu Wang on 31/12/19.
//  Copyright © 2019 Liyu Wang. All rights reserved.
//

import XCTest
@testable import WeatherApp

class WeatherViewModelTests: XCTestCase {
    var viewModel: WeatherViewModel!

    override func setUp() {
        viewModel = WeatherViewModel(repository: MockWeatherRepository())
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testFetchWeatherByName() {
        XCTFail("Not Implemented.")
    }

    func testFetchWeatherByZip() {
        XCTFail("Not Implemented.")
    }

    func testFetchWeatherByGPS() {
        XCTFail("not Implemented.")
    }
}
