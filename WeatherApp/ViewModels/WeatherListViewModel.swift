//
//  WeatherListViewModel.swift
//  WeatherApp
//
//  Created by Liyu Wang on 4/1/20.
//  Copyright © 2020 Liyu Wang. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct WeatherListViewModel {
    var weatherListObservable: Observable<[Weather]> {
        return weatherList.asObservable()
    }
    private let weatherList: BehaviorRelay<[Weather]>

    private let repository: WeatherRepositoryType
    private let bag = DisposeBag()

    init(repository: WeatherRepositoryType = WeatherRepository(weatherStore: RealmStore<Weather>())) {
        self.repository = repository
        weatherList = BehaviorRelay(value: [])
        fetchAllLocalWeathers()
    }

    func fetchAllLocalWeathers() {
        repository.fetchAllLocalWeathers()
            .bind(to: weatherList)
            .disposed(by: bag)
    }

    func delete(weather: Weather) {
        repository.delete(weather: weather)
    }
}
