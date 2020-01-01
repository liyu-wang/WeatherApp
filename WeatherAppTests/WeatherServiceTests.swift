//
//  WeatherServiceTests.swift
//  WeatherAppTests
//
//  Created by Liyu Wang on 1/1/20.
//  Copyright © 2020 Liyu Wang. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxBlocking
@testable import WeatherApp

class WeatherServiceTests: XCTestCase {
    var weatherService: WeatherServiceType!

    override func setUp() {
        super.setUp()
        weatherService = WeatherService()
    }

    override func tearDown() {
        weatherService = nil
        super.tearDown()
    }

    func testFetchWeather() {
        let result = weatherService.fetchWeather(with: [:])
            .toBlocking()
            .materialize()

        switch result {
        case .completed(let elements):
            XCTAssertTrue(elements.count == 1, "Expected to get 1 wearther observable back, but got \(elements.count) back.")
        case .failed(_, let error):
            XCTFail("Expected to get a weather back, but received \(error).")
        }
    }
}
