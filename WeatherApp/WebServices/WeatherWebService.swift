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
    func fetchWeather(byId id: Int) -> Single<Weather>
}

struct WeatherWebService: WeatherWebServiceType {
    private let service: Service<WeatherRequest>

    init(service: Service<WeatherRequest> = Service<WeatherRequest>()) {
        self.service = service
    }

    func fetchWeather(byCityName name: String) -> Single<Weather> {
        let request = FetchWeatherByCityNameRequest(q: name)
        return service.makeAPICall(.fetchWeatherByName(request), for: WeatherServiceData.self)
            .map { Weather(from: $0) }
    }

    func fetchWeather(byZip zip: String, countryCode: String) -> Single<Weather> {
        let request = FetchWeatherByZipRequest(zip: "\(zip),\(countryCode)")
        return service.makeAPICall(.fetchWeatherByZip(request), for: WeatherServiceData.self)
            .map { Weather(from: $0) }
    }

    func fetchWeather(byLatitude latitude: Double, longitude: Double) -> Single<Weather> {
        let request = FetchWeatherByCoordinatesRequest(lat: latitude, lon: longitude)
        return service.makeAPICall(.fetchWeatherByCoordinates(request), for: WeatherServiceData.self)
            .map { Weather(from: $0) }
    }

    func fetchWeather(byId id: Int) -> Single<Weather> {
        let request = FetchWeatherByIdRequest(id: id)
        return service.makeAPICall(.fetchWeatherById(request), for: WeatherServiceData.self)
            .map { Weather(from: $0) }
    }
}
