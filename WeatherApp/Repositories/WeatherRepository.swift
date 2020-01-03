//
//  WeatherRepository.swift
//  WeatherApp
//
//  Created by Wang, Liyu on 3/1/20.
//  Copyright © 2020 Liyu Wang. All rights reserved.
//

import Foundation
import RxSwift

protocol WeatherRepositoryType {
    func fetchWeather(byCityName name: String) -> Observable<Weather>
    func fetchWeather(byZip zip: String) -> Observable<Weather>
    func fetchWeather(byLatitude latitude: Double, longitude: Double) -> Observable<Weather>
    func fetchAllWeathers() -> Observable<[Weather]>
    func fetchMostRecentWeather() -> Observable<Weather?>
}

struct WeatherRepository: WeatherRepositoryType {
    private let weatherService: WeatherServiceType
    private let weatherStore: WeatherStoreType

    init(weatherService: WeatherServiceType = WeatherService(), weatherStore: WeatherStoreType = WeatherStore()) {
        self.weatherService = weatherService
        self.weatherStore = weatherStore
    }

    func fetchWeather(byCityName name: String) -> Observable<Weather> {
        return Observable.just(Weather())
    }

    func fetchWeather(byZip zip: String) -> Observable<Weather> {
        return Observable.just(Weather())
    }

    func fetchWeather(byLatitude latitude: Double, longitude: Double) -> Observable<Weather> {
        return Observable.just(Weather())
    }

    func fetchAllWeathers() -> Observable<[Weather]> {
        return Observable.just([])
    }

    func fetchMostRecentWeather() -> Observable<Weather?> {
        return Observable.just(nil)
    }
}
