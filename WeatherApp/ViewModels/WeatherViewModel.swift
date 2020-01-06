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
    var isLoadingDriver: Driver<Bool> {
        return isLoading.asDriver()
    }
    var errorObservable: Observable<Error> {
        return error.asObservable()
    }
    var weatherDrive: Driver<Weather> {
        return weather.asDriver()
    }
    private let isLoading: BehaviorRelay<Bool>
    private let error: PublishRelay<Error>
    private let weather: BehaviorRelay<Weather>
    private let bag = DisposeBag()

    private let repository: WeatherRepositoryType
    private let userDefaultsManager: UserDefaultsManagerType

    init(repository: WeatherRepositoryType = WeatherRepository(), userDefaultsManager: UserDefaultsManagerType = UserDefaultsManager.shared) {
        self.repository = repository
        self.userDefaultsManager = userDefaultsManager
        error = PublishRelay()
        isLoading = BehaviorRelay(value: false)
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
        isLoading.accept(true)
        repository.fetchWeather(byCityName: name)
            .subscribe(
                onNext: { weather in
                    self.weather.accept(weather)
                    self.userDefaultsManager.saveMostRecentWeahter(id: weather.id)
                },
                onError: { error in
                    self.error.accept(error)
                },
                onDisposed: {
                    self.isLoading.accept(false)
                }
            )
            .disposed(by: bag)
    }

    func fetchWeather(byZip zip: String, country: String) {
        isLoading.accept(true)
        repository.fetchWeather(byZip: zip, countryCode: country)
            .subscribe(
                onNext: { weather in
                    self.weather.accept(weather)
                    self.userDefaultsManager.saveMostRecentWeahter(id: weather.id)
                },
                onError: { error in
                    self.error.accept(error)
                },
                onDisposed: {
                    self.isLoading.accept(false)
                }
            )
            .disposed(by: bag)
    }

    func fetchWeatherByGPS() {

    }

    func fetchMostRecentWeather() {
        guard let wId = userDefaultsManager.loadMostRecentWeatherId() else { return }
        isLoading.accept(true)
        repository.fetchWeather(byId: wId)
            .subscribe(
                onNext: { weather in
                    self.weather.accept(weather)
                },
                onError: { error in
                    self.error.accept(error)
                },
                onDisposed: {
                    self.isLoading.accept(false)
                }
            )
            .disposed(by: bag)
    }
}
