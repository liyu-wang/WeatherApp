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

private struct Constants {
    static let zipFormatSeparator = ","
    static let defaultCountryCode = "AU"
}

struct WeatherViewModel {
    var weatherDrive: Driver<Weather> {
        return weather.asDriver(onErrorJustReturn: Weather.emptyWeather)
    }
    private let weather: BehaviorRelay<Weather>

    private let repository: WeatherRepositoryType
    private let userDefaultsManager: UserDefaultsManagerType
    private let bag = DisposeBag()

    init(repository: WeatherRepositoryType = WeatherRepository(), userDefaultsManager: UserDefaultsManagerType = UserDefaultsManager.shared) {
        self.repository = repository
        self.userDefaultsManager = userDefaultsManager
        weather = BehaviorRelay(value: Weather.emptyWeather)
    }

    func fetchWeather(text: String) {
        if text.containsNumbers() {
            let array = text.components(separatedBy: Constants.zipFormatSeparator)
            guard array.count > 0, array.count <= 2 else {
                // pop format error
                return
            }
            switch array.count {
            case 1:
                let countryCode = Locale.current.regionCode ?? Constants.defaultCountryCode
                fetchWeather(byZip: array[0].trimed(),
                             country: countryCode)
            case 2:
                fetchWeather(byZip: array[0].trimed(),
                             country: array[1].trimed())
            default:
                fatalError()
            }
        } else {
            fetchWeather(byCityName: text)
        }
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
