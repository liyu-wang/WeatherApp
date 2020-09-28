//
//  RMWeather.swift
//  WeatherApp
//
//  Created by Liyu Wang on 31/12/19.
//  Copyright © 2019 Liyu Wang. All rights reserved.
//

import Foundation
import RealmSwift

class RMWeather: Object {
    @objc dynamic var uid: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var country: String = ""
    @objc dynamic var latitude: Double = 0
    @objc dynamic var longitude: Double = 0
    @objc dynamic var dateTime: Date?
    @objc dynamic var condition: String = ""
    @objc dynamic var iconStr: String = ""
    @objc dynamic var temperature: Float = 0
    @objc dynamic var tempMin: Float = 0
    @objc dynamic var tempMax: Float = 0
    @objc dynamic var humidity: Int = 0
    @objc dynamic var timestamp: Date?

    override class func primaryKey() -> String? {
        return "uid"
    }

    override var description: String {
        return "\(super.description): \(uid) \(condition)"
    }
}

extension RMWeather: DomainModelConvertibleType {
    func asDomainModel() -> Weather {
        return Weather(uid: uid,
                       name: name,
                       country: country,
                       latitude: latitude,
                       longitude: longitude,
                       dateTime: dateTime,
                       condition: condition,
                       iconStr: iconStr,
                       temperature: temperature,
                       tempMin: tempMin,
                       tempMax: tempMax,
                       humidity: humidity,
                       timestamp: timestamp)
    }
}

extension Weather: RealmModelRepresentable {
    func asRealmModel() -> RMWeather {
        let weather = RMWeather()
        weather.uid = uid
        weather.name = name
        weather.country = country
        weather.latitude = latitude
        weather.longitude = longitude
        weather.dateTime = dateTime
        weather.condition = condition
        weather.iconStr = iconStr
        weather.temperature = temperature
        weather.tempMin = tempMin
        weather.tempMax = tempMax
        weather.humidity = humidity
        weather.timestamp = timestamp
        return weather
    }
}
