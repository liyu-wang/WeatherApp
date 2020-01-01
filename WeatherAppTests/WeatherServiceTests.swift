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

    func testFetchWeatherByCityNameSuccess() {
        let result = weatherService.fetchWeather(byCityName: "London")
            .toBlocking()
            .materialize()

        switch result {
        case .completed(let elements):
            XCTAssert(elements.count == 1, "Expected to get 1 wearther back, but got \(elements.count) back.")
        case .failed(_, let error):
            XCTFail("Expected to get a weather back, but received \(error).")
        }
    }

    func testFetchWeatherByZipCodeSuccess() {
        let result = weatherService.fetchWeather(byZip: "2000", countryCode: "au")
            .toBlocking()
            .materialize()

        switch result {
        case .completed(let elements):
            XCTAssert(elements.count == 1, "Expected to get 1 wearther back, but got \(elements.count) back.")
        case .failed(_, let error):
            XCTFail("Expected to get a weather back, but received \(error).")
        }
    }

    func testFetchWeatherByCoordinatesSuccess() {
        let result = weatherService.fetchWeather(byLatitude: -33.79, longitude: 151.10)
            .toBlocking()
            .materialize()

        switch result {
        case .completed(let elements):
            XCTAssert(elements.count == 1, "Expected to get 1 wearther back, but got \(elements.count) back.")
        case .failed(_, let error):
            XCTFail("Expected to get a weather back, but received \(error).")
        }
    }

    func testFetchWeatherByIdSuccess() {
        let result = weatherService.fetchWeather(byId: 2172797)
            .toBlocking()
            .materialize()

        switch result {
        case .completed(let elements):
            XCTAssert(elements.count == 1, "Expected to get 1 wearther back, but got \(elements.count) back.")
        case .failed(_, let error):
            XCTFail("Expected to get a weather back, but received \(error).")
        }
    }

    func testFetchWeatherByCityNameFailure() {
        let result = weatherService.fetchWeather(byCityName: "cityNotExist")
            .toBlocking()
            .materialize()

        switch result {
        case .completed(_):
            XCTFail("Expected result to be an error.")
        case .failed(let elements, let error):
            XCTAssert(elements.count == 0, "Expected no weather to be returned.")
            if let err = error as? WebServiceError,
                case .unacceptableStatusCode(let code, _) = err {
                XCTAssertEqual(code, 404, "Expected status code 404, but received \(code)")
            } else {
                XCTFail("Expected error to be WebServiceError.unacceptableStatusCode, but got the \(error)")
            }
        }
    }

    func testFetchWeatherByZipCodeFailure() {
        let result = weatherService.fetchWeather(byZip: "zipNotExist", countryCode: "countryNotExist")
            .toBlocking()
            .materialize()

        switch result {
        case .completed(_):
            XCTFail("Expected result to be an error.")
        case .failed(let elements, let error):
            XCTAssert(elements.count == 0, "Expected no weather to be returned.")
            if let err = error as? WebServiceError,
                case .unacceptableStatusCode(let code, _) = err {
                XCTAssertEqual(code, 404, "Expected status code 404, but received \(code)")
            } else {
                XCTFail("Expected error to be WebServiceError.unacceptableStatusCode, but got the \(error)")
            }
        }
    }

    func testFetchWeatherByCoordinatesFailure() {
        let result = weatherService.fetchWeather(byLatitude: 123456789, longitude: 987654321)
            .toBlocking()
            .materialize()

        switch result {
        case .completed(_):
            XCTFail("Expected result to be an error.")
        case .failed(let elements, let error):
            XCTAssert(elements.count == 0, "Expected no weather to be returned.")
            if let err = error as? WebServiceError,
                case .unacceptableStatusCode(let code, _) = err {
                XCTAssertEqual(code, 400, "Expected status code 400, but received \(code)")
            } else {
                XCTFail("Expected error to be WebServiceError.unacceptableStatusCode, but got the \(error)")
            }
        }
    }
}
