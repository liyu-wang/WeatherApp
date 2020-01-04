//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Liyu Wang on 4/1/20.
//  Copyright © 2020 Liyu Wang. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct WeatherViewModel {
    var weatherDrive: Driver<Weather?> {
        return weather.asDriver(onErrorJustReturn: nil)
    }
    private let weather: BehaviorRelay<Weather?>

    private let repository: WeatherRepositoryType

    init(repository: WeatherRepositoryType = WeatherRepository()) {
        self.repository = repository
        weather = BehaviorRelay(value: nil)
    }

    func fetchWeather(byCityName name: String) {

    }

    func fetchWeather(byZip zip: String, country: String) {

    }

    func fetchWeatherByGPS() {

    }

    func fetchMostRecentWeather() {

    }
}
