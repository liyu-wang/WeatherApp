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

    func fetchAllLocalWeathers() -> Observable<[Weather]> {
        return weathers.asObservable()
    }

    func delete(weather: Weather) -> Observable<Void> {
        guard let i = localWeatherArray.firstIndex(of: weather) else {
            return Observable.error(WeatherStoreError.weatherWithSpecifiedIdNotExist(id: weather.id))
        }
        localWeatherArray.remove(at: i)
        weathers.accept(localWeatherArray)
        return Observable.just(())
    }

    func fetchWeather(byCityName name: String) -> Observable<Weather> {
        return Observable.just(TestDataSet.remoteWeatherLondon)
    }

    func fetchWeather(byZip zip: String, countryCode: String) -> Observable<Weather> {
        return Observable.just(TestDataSet.remoteWeatherLondon)
    }

    func fetchWeather(byLatitude latitude: Double, longitude: Double) -> Observable<Weather> {
        return Observable.just(TestDataSet.remoteWeatherLondon)
    }

    func fetchWeather(byId id: Int) -> Observable<Weather> {
        guard id == TestDataSet.localWeatherLondon.id else { return Observable.error(WeatherStoreError.weatherWithSpecifiedIdNotExist(id: id)) }
        return Observable.from([TestDataSet.localWeatherLondon, TestDataSet.remoteWeatherLondon])
    }
}
