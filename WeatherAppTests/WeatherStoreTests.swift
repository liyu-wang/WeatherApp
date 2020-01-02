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
@testable import WeatherApp

class WeatherStoreTests: XCTestCase {
    var weatherStore: WeatherStoreType!

    override func setUp() {
        super.setUp()
        weatherStore = WeatherStore()
    }

    override func tearDown() {
        weatherStore = nil
        super.tearDown()
    }

    func testFetchAll() {
        let result = weatherStore.fetchAll()
            .toBlocking()
            .materialize()

        switch result {
        case .completed(let elements):
            XCTAssertTrue(elements.count == 1, "Expected to get 1 observable back, but got \(elements.count) back.")
            XCTAssertTrue(elements.first?.count == 0, "Expected to get 0 wearther, but got \(String(describing: elements.first?.count)) back.")
        case .failed(_, let error):
            XCTFail("Expected to get a weather back, but received \(error).")
        }
    }

    func testFetchMostRecent() {
        let result = weatherStore.fetchMostRecent()
        .toBlocking()
        .materialize()

        switch result {
        case .completed(let elements):
            XCTAssertTrue(elements.count == 1, "Expected to get 1 wearther observable back, but got \(elements.count) back.")
        case .failed(_, let error):
            XCTFail("Expected to get a weather back, but received \(error).")
        }
    }

    func testAddWeather() {

    }

    func testUpdateWeather() {

    }

    func testDeleteWeather() {

    }
}
