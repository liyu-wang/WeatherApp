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
    private let userDefaultsManager: UserDefaultsManagerType
    private let bag = DisposeBag()

    init(repository: WeatherRepositoryType = WeatherRepository(), userDefaultsManager: UserDefaultsManagerType = UserDefaultsManager.shared) {
        self.repository = repository
        self.userDefaultsManager = userDefaultsManager
        weather = BehaviorRelay(value: nil)
    }

    func fetchWeather(byCityName name: String) {
        repository.fetchWeather(byCityName: name)
            .bind(to: weather)
            .disposed(by: bag)
    }

    func fetchWeather(byZip zip: String, country: String) {
        repository.fetchWeather(byZip: zip, countryCode: country)
            .bind(to: weather)
            .disposed(by: bag)
    }

    func fetchWeatherByGPS() {

    }

    func fetchMostRecentWeather() {
        guard let wId = userDefaultsManager.loadMostRecentWeatherId() else { return }
        repository.fetchWeather(byId: wId)
            .bind(to: weather)
            .disposed(by: bag)
    }
}
