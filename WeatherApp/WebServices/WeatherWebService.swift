//
//  WeatherWebService.swift
//  WeatherApp
//
//  Created by Liyu Wang on 26/7/20.
//  Copyright © 2020 Liyu Wang. All rights reserved.
//

import Foundation
import RxSwift

protocol WeatherWebServiceType {
    func fetchWeather(byCityName name: String) -> Single<Weather>
    func fetchWeather(byZip zip: String, countryCode: String) -> Single<Weather>
    func fetchWeather(byLatitude latitude: Double, longitude: Double) -> Single<Weather>
    func fetchWeather(byId id: String) -> Single<Weather>
}

struct WeatherWebService: WeatherWebServiceType {
    private let service: Service<WeatherAPI>

    init(service: Service<WeatherAPI> = Service<WeatherAPI>()) {
        self.service = service
    }

    func fetchWeather(byCityName name: String) -> Single<Weather> {
        return service.makeAPICall(.fetchWeather(["q": name]), for: WeatherResponseData.self)
            .map { Weather(from: $0) }
    }

    func fetchWeather(byZip zip: String, countryCode: String) -> Single<Weather> {
        return service.makeAPICall(.fetchWeather(["zip": "\(zip),\(countryCode)"]), for: WeatherResponseData.self)
            .map { Weather(from: $0) }
    }

    func fetchWeather(byLatitude latitude: Double, longitude: Double) -> Single<Weather> {
        return service.makeAPICall(.fetchWeather(["lat": latitude, "lon": longitude]), for: WeatherResponseData.self)
            .map { Weather(from: $0) }
    }

    func fetchWeather(byId id: String) -> Single<Weather> {
        return service.makeAPICall(.fetchWeather(["id": id]), for: WeatherResponseData.self)
            .map { Weather(from: $0) }
    }
}
