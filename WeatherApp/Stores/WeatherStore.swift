//
//  RealmStore.swift
//  WeatherApp
//
//  Created by Liyu Wang on 2/1/20.
//  Copyright © 2020 Liyu Wang. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
import RxRealm

protocol AbstractStore {
    associatedtype Entity
    func fetchMostRecentEntity() -> Maybe<Entity>
    func fetchAll() -> Observable<[Entity]>
    func find(by id: Int) -> Maybe<Entity>
    @discardableResult
    func add(entity: Entity) -> Observable<Void>
    @discardableResult
    func addOrUpdate(entity: Entity) -> Observable<Void>
    @discardableResult
    func update(entity: Entity) -> Observable<Void>
    @discardableResult
    func delete(entity: Entity) -> Observable<Void>
}

struct RealmStore<E: Object>: AbstractStore {
    func fetchMostRecentEntity() -> Maybe<E> {
        guard let realm = RealmManager.realm else { return Maybe.error(StoreError.failedToInitDBInstance) }
        if let entity = realm.objects(E.self).sorted(byKeyPath: "timestamp", ascending: false).first {
            return Maybe.just(entity)
        } else {
            return Maybe.empty()
        }
    }

    func fetchAll() -> Observable<[E]> {
        guard let realm = RealmManager.realm else { return Observable.error(StoreError.failedToInitDBInstance) }
        let result = realm.objects(E.self).sorted(byKeyPath: "timestamp", ascending: false)
        return Observable.array(from: result)
    }

    func find(by id: Int) -> Maybe<E> {
        guard let realm = RealmManager.realm else { return Maybe.error(StoreError.failedToInitDBInstance) }
        if let entity = realm.object(ofType: E.self, forPrimaryKey: id) {
            return Maybe.just(entity)
        } else {
            return Maybe.empty()
        }
    }

    func add(entity: E) -> Observable<Void> {
        return RealmManager.write { realm in
            realm.add(entity)
        }
    }

    func addOrUpdate(entity: E) -> Observable<Void> {
        return RealmManager.write { realm in
            realm.add(entity, update: .modified)
        }
    }

    func update(entity: E) -> Observable<Void> {
        return RealmManager.write { realm in
            realm.add(entity, update: .modified)
        }
    }

    func delete(entity: E) -> Observable<Void> {
        return RealmManager.write { realm in
            realm.delete(entity)
        }
    }
}
