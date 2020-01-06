//
//  RealmManager.swift
//  WeatherApp
//
//  Created by Liyu Wang on 2/1/20.
//  Copyright © 2020 Liyu Wang. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

typealias RealmWriteBlock = (_ realm: Realm) -> Void

private struct Constants {
    static let dbVersion: UInt64 = 1
}

struct RealmManager {
    static let sharedInstance = RealmManager()

    let config = Realm.Configuration(
        schemaVersion: Constants.dbVersion,

        migrationBlock: { migration, oldSchemaVersion in
            if (oldSchemaVersion < Constants.dbVersion) {
                // Nothing to do!
                // Realm will automatically detect new properties and removed properties
                // And will update the schema on disk automatically
            }
        }
    )

    func configRealm() {
        Realm.Configuration.defaultConfiguration = config
    }
}

extension RealmManager {
    public static var realm: Realm? {
        do {
            return try Realm()
        } catch {
            fatalError("Failed to create realm instance: \(error)")
        }
    }

    @discardableResult
    public static func write(with realm: Realm? = RealmManager.realm, _ block: RealmWriteBlock) -> Observable<Void> {
        do {
            try realm?.write {
                block(realm!)
            }
            return Observable.just(())
        } catch {
            debugPrint("Could not write to database: %@", error)
            return Observable.error(WeatherStoreError.failedToWriteDB(error: error))
        }
    }
}
