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
    func fetchMostRecent() -> Observable<Weather?>
    func add(weather: Weather)
    func update(weather: Weather)
    func delete(weather: Weather)
}

struct WeatherStore: WeatherStoreType {
    func fetchAll() -> Observable<[Weather]> {
        guard let realm = RealmManager.realm else { return Observable.just([]) }
        let result = realm.objects(Weather.self).sorted(byKeyPath: "timestamp", ascending: false)
        return Observable.array(from: result)
    }

    func fetchMostRecent() -> Observable<Weather?> {
        guard let realm = RealmManager.realm else { return Observable.just(nil) }
        let mostRecentWeahter = realm.objects(Weather.self).sorted(byKeyPath: "timestamp", ascending: false).first
        return Observable.just(mostRecentWeahter)
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
