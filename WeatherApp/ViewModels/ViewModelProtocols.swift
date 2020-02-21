//
//  ViewModelProtocols.swift
//  WeatherApp
//
//  Created by Liyu Wang on 17/2/20.
//  Copyright © 2020 Liyu Wang. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol LoadingStatusEmitable {
    var isLoadingDriver: Driver<Bool> { get }
    var hasLoadedDriver: Driver<Bool> { get }
}

protocol ErrorEmitable {
    var errorObservable: Observable<Error> { get }
}

// MARK: - WeatherViewModelType

typealias WeatherViewModelType = LoadingStatusEmitable & ErrorEmitable & WeatherEmitable & WeatherQueryable

protocol WeatherEmitable {
    var weatherDriver: Driver<Weather> { get }
}

protocol WeatherQueryable {
    func fetchWeather(text: String)
    func fetchWeather(byCityName name: String)
    func fetchWeather(byZip zip: String, country: String)
    func fetchWeatherByGPS()
    func fetchMostRecentWeather()
}

// MARK: - WeatherListViewModelType

typealias WeatherListViewModelType = WeatherListEmitable & WeatherListFetchable & WeatherListEditable

protocol WeatherListEmitable {
    var weatherListObservable: Observable<[Weather]> { get }
}

protocol WeatherListFetchable {
    func fetchAllLocalWeathers()
}

protocol WeatherListEditable {
    func delete(weather: Weather)
}
