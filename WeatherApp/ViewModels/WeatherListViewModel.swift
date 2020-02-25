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
    private let weatherList: BehaviorRelay<[Weather]>
    private let repository: WeatherRepositoryType
    private let bag = DisposeBag()

    init(repository: WeatherRepositoryType = WeatherRepository(weatherStore: RealmStore<Weather>())) {
        self.repository = repository
        weatherList = BehaviorRelay(value: [])
        fetchAllLocalWeathers()
    }
}

extension WeatherListViewModel: WeatherListEmitable {
    var weatherListObservable: Observable<[Weather]> {
        return weatherList.asObservable()
    }
}

extension WeatherListViewModel: WeatherListFetchable {
    func fetchAllLocalWeathers() {
        repository.fetchAllLocalWeathers()
            .bind(to: weatherList)
            .disposed(by: bag)
    }
}

extension WeatherListViewModel: WeatherListEditable {
    func delete(weather: Weather) {
        repository.delete(weather: weather)
    }
}

extension WeatherListViewModel: WeatherIndexable {
    func weather(at indexPath: IndexPath) -> Weather {
        return weatherList.value[indexPath.row]
    }
}
