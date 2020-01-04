//
//  MockWeatherRepository.swift
//  WeatherAppTests
//
//  Created by Liyu Wang on 4/1/20.
//  Copyright © 2020 Liyu Wang. All rights reserved.
//

import Foundation
import RxSwift
@testable import WeatherApp

 class MockWeatherRepository: WeatherRepositoryType {
    func fetchWeather(byCityName name: String) -> Observable<Weather> {
        return Observable.just(Weather())
    }

    func fetchWeather(byZip zip: String, countryCode: String) -> Observable<Weather> {
        return Observable.just(Weather())
    }

    func fetchWeather(byLatitude latitude: Double, longitude: Double) -> Observable<Weather> {
        return Observable.just(Weather())
    }

    func fetchWeather(byId id: Int) -> Observable<Weather> {
        return Observable.just(Weather())
    }

    func fetchAllLocalWeathers() -> Observable<[Weather]> {
        return Observable.just([])
    }
}
