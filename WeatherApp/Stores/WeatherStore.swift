//
//  WeatherStore.swift
//  WeatherApp
//
//  Created by Liyu Wang on 2/1/20.
//  Copyright © 2020 Liyu Wang. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
import RxRealm

protocol WeatherStoreType {
    func fetchAll() -> Observable<[Weather]>
    func find(by id: Int) -> Observable<Weather>
    func add(weather: Weather)
    func update(weather: Weather)
    func delete(weather: Weather)
}

struct WeatherStore: WeatherStoreType {
    func fetchAll() -> Observable<[Weather]> {
        guard let realm = RealmManager.realm else { return Observable.error(WeatherStoreError.failedToInitDBInstance) }
        let result = realm.objects(Weather.self).sorted(byKeyPath: "timestamp", ascending: false)
        return Observable.array(from: result)
    }

    func find(by id: Int) -> Observable<Weather> {
        guard let realm = RealmManager.realm else { return Observable.error(WeatherStoreError.failedToInitDBInstance) }
        guard let weather = realm.object(ofType: Weather.self, forPrimaryKey: id) else {
            return Observable.error(WeatherStoreError.weatherWithSpecifiedIdNotExist(id: id))
        }
        return Observable.just(weather)
    }

    func add(weather: Weather) {
        RealmManager.write { realm in
            realm.add(weather)
        }
    }

    func update(weather: Weather) {
        RealmManager.write { realm in
            realm.add(weather, update: .modified)
        }
    }

    func delete(weather: Weather) {
        RealmManager.write { realm in
            realm.delete(weather)
        }
    }
}
