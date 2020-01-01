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
    convenience init(from weatherServiceData: WeatherServiceData) {
        self.init()
        id = weatherServiceData.id
        name = weatherServiceData.name
        country = weatherServiceData.sys.country
        latitude = weatherServiceData.coord.lat
        longitude = weatherServiceData.coord.lon
        dateTime = Date(timeIntervalSince1970: TimeInterval(weatherServiceData.dt))
        condition = weatherServiceData.weather.first?.main ?? ""
        iconStr = weatherServiceData.weather.first?.icon ?? ""
        temperature = weatherServiceData.main.temp
        tempMin = weatherServiceData.main.tempMin
        tempMax = weatherServiceData.main.tempMax
        humidity = weatherServiceData.main.humidity
        timestamp = Date()
    }
}
