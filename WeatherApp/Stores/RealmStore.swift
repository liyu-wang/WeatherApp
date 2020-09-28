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

struct SortKey {
    let keyPath: String
    let ascending: Bool
}

protocol SortableByTime {
    static var timeSortKey: SortKey { get }
}

protocol AbstractStore {
    associatedtype Entity
    func fetchAll(sortKey: SortKey?) -> Observable<[Entity]>
    func find(by id: String) -> Maybe<Entity>
    @discardableResult
    func add(entity: Entity) -> Observable<Void>
    @discardableResult
    func addOrUpdate(entity: Entity) -> Observable<Void>
    @discardableResult
    func update(entity: Entity) -> Observable<Void>
    @discardableResult
    func delete(entity: Entity) -> Observable<Void>
}

extension AbstractStore where Entity: RealmModelRepresentable & SortableByTime, Entity == Entity.RealmModelType.DomainModelType, Entity.RealmModelType: Object {
    func fetchMostRecentEntity(sortKey: SortKey?) -> Maybe<Entity> {
        guard let realm = RealmManager.realm else { return Maybe.error(StoreError.failedToInitDBInstance) }
        let timeSortKey = Entity.timeSortKey
        if let entity = realm.objects(Entity.RealmModelType.self).sorted(byKeyPath: timeSortKey.keyPath, ascending: timeSortKey.ascending).first {
            return Maybe.just(entity.asDomainModel())
        } else {
            return Maybe.empty()
        }
    }
}

struct RealmStore<T: RealmModelRepresentable>: AbstractStore where T == T.RealmModelType.DomainModelType, T.RealmModelType: Object {
    func fetchAll(sortKey: SortKey? = nil) -> Observable<[T]> {
        guard let realm = RealmManager.realm else { return Observable.error(StoreError.failedToInitDBInstance) }
        var result = realm.objects(T.RealmModelType.self)
        if let sort = sortKey {
            result = result.sorted(byKeyPath: sort.keyPath, ascending: sort.ascending)
        }
        return Observable.array(from: result).mapToDomainModels()
    }

    func find(by id: String) -> Maybe<T> {
        guard let realm = RealmManager.realm else { return Maybe.error(StoreError.failedToInitDBInstance) }
        if let entity = realm.object(ofType: T.RealmModelType.self, forPrimaryKey: id) {
            return Maybe.just(entity.asDomainModel())
        } else {
            return Maybe.empty()
        }
    }

    func add(entity: T) -> Observable<Void> {
        return RealmManager.write { realm in
            realm.add(entity.asRealmModel())
        }
    }

    func addOrUpdate(entity: T) -> Observable<Void> {
        return RealmManager.write { realm in
            realm.add(entity.asRealmModel(), update: .modified)
        }
    }

    func update(entity: T) -> Observable<Void> {
        return RealmManager.write { realm in
            realm.add(entity.asRealmModel(), update: .modified)
        }
    }

    func delete(entity: T) -> Observable<Void> {
        guard let realm = RealmManager.realm else { return Observable.error(StoreError.failedToInitDBInstance) }
        guard let object = realm.object(ofType: T.RealmModelType.self, forPrimaryKey: entity.uid) else { fatalError() }
        return RealmManager.write { realm in
            realm.delete(object)
        }
    }
}
