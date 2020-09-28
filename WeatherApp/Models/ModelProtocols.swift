//
//  ModelProtocols.swift
//  WeatherApp
//
//  Created by Liyu Wang on 23/8/20.
//  Copyright © 2020 Liyu Wang. All rights reserved.
//

import Foundation

protocol DomainModelConvertibleType {
    associatedtype DomainModelType

    func asDomainModel() -> DomainModelType
}

protocol RealmModelRepresentable {
    associatedtype RealmModelType: DomainModelConvertibleType

    var uid: String { get }
    func asRealmModel() -> RealmModelType
}
