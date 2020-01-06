//
//  MapViewModel.swift
//  WeatherApp
//
//  Created by Liyu Wang on 6/1/20.
//  Copyright © 2020 Liyu Wang. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MapViewModel {
    var weatherDriver: Driver<Weather> {
        return weather.asDriver()
    }
    private let weather: BehaviorRelay<Weather>

    init(weather: Weather) {
        self.weather = BehaviorRelay<Weather>(value: weather)
    }
}
