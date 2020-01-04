//
//  WeatherListViewModelTests.swift
//  WeatherAppTests
//
//  Created by Liyu Wang on 4/1/20.
//  Copyright © 2020 Liyu Wang. All rights reserved.
//

import XCTest
@testable import WeatherApp

class WeatherListViewModelTests: XCTestCase {
    var viewModel: WeatherListViewModel!

    override func setUp() {
        viewModel = WeatherListViewModel(repository: MockWeatherRepository())
        super.setUp()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testFetchAllLocalWeathers() {
        XCTFail("Not implemented.")
    }
}
