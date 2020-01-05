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
    func fetchWeather(byZip zip: String, countryCode: String) -> Observable<Weather>
    func fetchWeather(byLatitude latitude: Double, longitude: Double) -> Observable<Weather>
    func fetchWeather(byId id: Int) -> Observable<Weather>
    func fetchAllLocalWeathers() -> Observable<[Weather]>
    @discardableResult
    func delete(weather: Weather) -> Observable<Void>
}

struct WeatherRepository: WeatherRepositoryType {
    private let weatherService: WeatherServiceType
    private let weatherStore: WeatherStoreType

    init(weatherService: WeatherServiceType = WeatherService(), weatherStore: WeatherStoreType = WeatherStore()) {
        self.weatherService = weatherService
        self.weatherStore = weatherStore
    }

    func fetchWeather(byCityName name: String) -> Observable<Weather> {
        return weatherService.fetchWeather(byCityName: name)
            .do(
                onNext: { weather in
                    self.weatherStore.addOrUpdate(weather: weather)
                }
            )
    }

    func fetchWeather(byZip zip: String, countryCode: String) -> Observable<Weather> {
        return weatherService.fetchWeather(byZip: zip, countryCode: countryCode)
            .do(
                onNext: { weather in
                    self.weatherStore.addOrUpdate(weather: weather)
                }
            )
    }

    func fetchWeather(byLatitude latitude: Double, longitude: Double) -> Observable<Weather> {
        return weatherService.fetchWeather(byLatitude: latitude, longitude: longitude)
            .do(
                onNext: { weather in
                    self.weatherStore.addOrUpdate(weather: weather)
                }
            )
    }

    func fetchWeather(byId id: Int) -> Observable<Weather> {
        let localFetch = Observable.merge(weatherStore.find(by: id))
        let remoteFetch = weatherService.fetchWeather(byId: id)
            .do(
                onNext: { weather in
                    self.weatherStore.addOrUpdate(weather: weather)
                }
            )
        return Observable.merge(localFetch, remoteFetch)
    }

    func fetchAllLocalWeathers() -> Observable<[Weather]> {
        return weatherStore.fetchAll()
    }

    func delete(weather: Weather) -> Observable<Void> {
        return weatherStore.delete(weather: weather)
    }
}
