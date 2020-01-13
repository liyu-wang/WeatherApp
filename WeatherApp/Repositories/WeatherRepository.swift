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
    func fetchMostRecentWeather() -> Observable<Weather>
    func fetchWeather(byCityName name: String) -> Single<Weather>
    func fetchWeather(byZip zip: String, countryCode: String) -> Single<Weather>
    func fetchWeather(byLatitude latitude: Double, longitude: Double) -> Single<Weather>
    func fetchWeather(byId id: Int, startWithLocalCopy: Bool) -> Observable<Weather>
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

    func fetchMostRecentWeather() -> Observable<Weather> {
        return weatherStore.fetchMostRecentWeather()
            .asObservable()
            .flatMapLatest { weather -> Observable<Weather> in
                return Observable.merge(
                    Observable.just(weather),
                    self.fetchWeather(byId: weather.id)
                )
            }
    }

    func fetchWeather(byCityName name: String) -> Single<Weather> {
        return weatherService.fetchWeather(byCityName: name)
            .observeOn(MainScheduler.instance)
            .do(
                onSuccess: { weather in
                    self.weatherStore.addOrUpdate(weather: weather)
                }
            )
    }

    func fetchWeather(byZip zip: String, countryCode: String) -> Single<Weather> {
        return weatherService.fetchWeather(byZip: zip, countryCode: countryCode)
            .observeOn(MainScheduler.instance)
            .do(
                onSuccess: { weather in
                    self.weatherStore.addOrUpdate(weather: weather)
                }
            )
    }

    func fetchWeather(byLatitude latitude: Double, longitude: Double) -> Single<Weather> {
        return weatherService.fetchWeather(byLatitude: latitude, longitude: longitude)
            .observeOn(MainScheduler.instance)
            .do(
                onSuccess: { weather in
                    self.weatherStore.addOrUpdate(weather: weather)
                }
            )
    }

    func fetchWeather(byId id: Int, startWithLocalCopy: Bool = false) -> Observable<Weather> {
        let localFetch = weatherStore.find(by: id)
            .asObservable()
        let remoteFetch = weatherService.fetchWeather(byId: id)
            .observeOn(MainScheduler.instance)
            .do(
                onSuccess: { weather in
                    self.weatherStore.addOrUpdate(weather: weather)
                }
            )
        if startWithLocalCopy {
            return Observable.merge(localFetch, remoteFetch.asObservable())
        } else {
            return remoteFetch.asObservable()
        }
    }

    func fetchAllLocalWeathers() -> Observable<[Weather]> {
        return weatherStore.fetchAll()
    }

    func delete(weather: Weather) -> Observable<Void> {
        return weatherStore.delete(weather: weather)
    }
}
