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
    var weatherListDrive: Driver<[Weather]> {
        return weatherList.asDriver(onErrorJustReturn: [])
    }
    private let weatherList: BehaviorRelay<[Weather]>

    private let repository: WeatherRepositoryType
    private let bag = DisposeBag()

    init(repository: WeatherRepositoryType = WeatherRepository()) {
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
