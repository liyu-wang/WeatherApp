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
    func fetchMostRecentWeather() -> Observable<Weather?>
    func fetchAll() -> Observable<[Weather]>
    func find(by id: Int) -> Observable<Weather?>
    @discardableResult
    func add(weather: Weather) -> Observable<Void>
    @discardableResult
    func addOrUpdate(weather: Weather) -> Observable<Void>
    @discardableResult
    func update(weather: Weather) -> Observable<Void>
    @discardableResult
    func delete(weather: Weather) -> Observable<Void>
}

struct WeatherStore: WeatherStoreType {
    func fetchMostRecentWeather() -> Observable<Weather?> {
        guard let realm = RealmManager.realm else { return Observable.error(WeatherStoreError.failedToInitDBInstance) }
        let weather = realm.objects(Weather.self).sorted(byKeyPath: "timestamp", ascending: false).first
        return Observable.just(weather)
    }

    func fetchAll() -> Observable<[Weather]> {
        guard let realm = RealmManager.realm else { return Observable.error(WeatherStoreError.failedToInitDBInstance) }
        let result = realm.objects(Weather.self).sorted(byKeyPath: "timestamp", ascending: false)
        return Observable.array(from: result)
    }

    func find(by id: Int) -> Observable<Weather?> {
        guard let realm = RealmManager.realm else { return Observable.error(WeatherStoreError.failedToInitDBInstance) }
        let weather = realm.object(ofType: Weather.self, forPrimaryKey: id)
        return Observable.just(weather)
    }

    func add(weather: Weather) -> Observable<Void> {
        return RealmManager.write { realm in
            realm.add(weather)
        }
    }

    func addOrUpdate(weather: Weather) -> Observable<Void> {
        return RealmManager.write { realm in
            realm.add(weather, update: .modified)
        }
    }

    func update(weather: Weather) -> Observable<Void> {
        return RealmManager.write { realm in
            realm.add(weather, update: .modified)
        }
    }

    func delete(weather: Weather) -> Observable<Void> {
        return RealmManager.write { realm in
            realm.delete(weather)
        }
    }
}
