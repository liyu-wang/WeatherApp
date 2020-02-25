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
    func fetchMostRecentWeather(skipLocal: Bool) -> Observable<Weather>
    func fetchWeather(byCityName name: String) -> Single<Weather>
    func fetchWeather(byZip zip: String, countryCode: String) -> Single<Weather>
    func fetchWeather(byLatitude latitude: Double, longitude: Double) -> Single<Weather>
    func fetchWeather(byId id: Int, startWithLocalCopy: Bool) -> Observable<Weather>
    func fetchAllLocalWeathers() -> Observable<[Weather]>
    @discardableResult
    func delete(weather: Weather) -> Observable<Void>
}

struct WeatherRepository<Store: AbstractStore>: WeatherRepositoryType where Store.Entity == Weather {
    private let weatherStore: Store
    private let weatherService: WeatherServiceType

    init(weatherStore: Store, weatherService: WeatherServiceType = WeatherService()) {
        self.weatherStore = weatherStore
        self.weatherService = weatherService
    }

    func fetchMostRecentWeather(skipLocal: Bool) -> Observable<Weather> {
        return weatherStore.fetchMostRecentEntity()
            .asObservable()
            .flatMapLatest { weather -> Observable<Weather> in
                if skipLocal {
                    return self.fetchWeather(byId: weather.id)
                }
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
                    self.weatherStore.addOrUpdate(entity: weather)
                }
            )
    }

    func fetchWeather(byZip zip: String, countryCode: String) -> Single<Weather> {
        return weatherService.fetchWeather(byZip: zip, countryCode: countryCode)
            .observeOn(MainScheduler.instance)
            .do(
                onSuccess: { weather in
                    self.weatherStore.addOrUpdate(entity: weather)
                }
            )
    }

    func fetchWeather(byLatitude latitude: Double, longitude: Double) -> Single<Weather> {
        return weatherService.fetchWeather(byLatitude: latitude, longitude: longitude)
            .observeOn(MainScheduler.instance)
            .do(
                onSuccess: { weather in
                    self.weatherStore.addOrUpdate(entity: weather)
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
                    self.weatherStore.addOrUpdate(entity: weather)
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
        return weatherStore.delete(entity: weather)
    }
}
