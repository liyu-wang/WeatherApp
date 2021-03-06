//
//  MockWeatherRepository.swift
//  WeatherAppTests
//
//  Created by Liyu Wang on 4/1/20.
//  Copyright © 2020 Liyu Wang. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
@testable import WeatherApp

class MockWeatherRepository: WeatherRepositoryType {
    private var localWeatherArray: [Weather] = [
        TestDataSet.localWeatherLondon,
        TestDataSet.localWeatherShuzenji
    ]
    private var weathers: BehaviorRelay<[Weather]>

    init() {
        self.weathers = BehaviorRelay(value: localWeatherArray)
    }

    func fetchMostRecentWeather(skipLocal: Bool) -> Observable<Weather> {
        if skipLocal {
            return Observable.just(TestDataSet.remoteWeatherLondon)
        }
        return Observable.from([TestDataSet.localWeatherLondon, TestDataSet.remoteWeatherLondon])
    }

    func fetchAllLocalWeathers() -> Observable<[Weather]> {
        return weathers.asObservable()
    }

    func delete(weather: Weather) -> Observable<Void> {
        guard let i = localWeatherArray.firstIndex(of: weather) else {
            return Observable.error(StoreError.entityWithSpecifiedIdNotExist(id: weather.uid))
        }
        localWeatherArray.remove(at: i)
        weathers.accept(localWeatherArray)
        return Observable.just(())
    }

    func fetchWeather(byCityName name: String) -> Single<Weather> {
        return Single.just(TestDataSet.remoteWeatherLondon)
    }

    func fetchWeather(byZip zip: String, countryCode: String) -> Single<Weather> {
        return Single.just(TestDataSet.remoteWeatherLondon)
    }

    func fetchWeather(byLatitude latitude: Double, longitude: Double) -> Single<Weather> {
        return Single.just(TestDataSet.remoteWeatherLondon)
    }

    func fetchWeather(byId id: String, startWithLocalCopy: Bool) -> Observable<Weather> {
        guard id == TestDataSet.localWeatherLondon.uid else { return Observable.error(StoreError.entityWithSpecifiedIdNotExist(id: id)) }
        guard startWithLocalCopy else {
            return Observable.just(TestDataSet.remoteWeatherLondon)
        }
        return Observable.from([
            TestDataSet.localWeatherLondon,
            TestDataSet.remoteWeatherLondon
        ])
    }
}
