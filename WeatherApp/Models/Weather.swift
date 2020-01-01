//
//  City.swift
//  WeatherApp
//
//  Created by Liyu Wang on 31/12/19.
//  Copyright © 2019 Liyu Wang. All rights reserved.
//

import Foundation
import RealmSwift

class Weather: Object {
    @objc dynamic var id: Int = 0
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
        return "id"
    }

    override var description: String {
        return "\(super.description): \(id) \(condition)"
    }
}

extension Weather {
    var iconURL: URL? {
        let urlStr = String(format: WebServiceConstants.iconURL, iconStr)
        return URL(string: urlStr)
    }
}

extension Weather {
    convenience init(from weatherData: WeatherData) {
        self.init()
        id = weatherData.id
        name = weatherData.name
        country = weatherData.sys.country
        latitude = weatherData.coord.lat
        longitude = weatherData.coord.lon
        dateTime = Date(timeIntervalSince1970: TimeInterval(weatherData.dt))
        condition = weatherData.weather.main
        iconStr = weatherData.weather.icon
        temperature = weatherData.main.temp
        tempMin = weatherData.main.tempMin
        tempMax = weatherData.main.tempMax
        humidity = weatherData.main.humidity
        timestamp = Date()
    }
}
