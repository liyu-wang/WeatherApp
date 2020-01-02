//
//  WeatherStore.swift
//  WeatherApp
//
//  Created by Liyu Wang on 2/1/20.
//  Copyright © 2020 Liyu Wang. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

protocol WeatherStoreType {
    func fetchAll() -> Observable<[Weather]>
    func fetchMostRecent() -> Observable<Weather?>
    func add(weather: Weather)
    func update(weather: Weather)
    func delete(weather: Weather)
}

struct WeatherStore: WeatherStoreType {
    func fetchAll() -> Observable<[Weather]> {
        return Observable.just([])
    }

    func fetchMostRecent() -> Observable<Weather?> {
        return Observable.just(Weather())
    }

    func add(weather: Weather) {

    }

    func update(weather: Weather) {
        
    }

    func delete(weather: Weather) {

    }
}
