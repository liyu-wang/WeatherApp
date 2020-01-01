//
//  WeatherWebService.swift
//  WeatherApp
//
//  Created by Liyu Wang on 1/1/20.
//  Copyright © 2020 Liyu Wang. All rights reserved.
//

import Foundation
import RxSwift

struct WebServiceConstants {
    static let baseURL = "http://api.openweathermap.org/data/2.5/weather"
    static let iconURL = "http://openweathermap.org/img/wn/%@@2x.png"
    static let secretKey = "95d190a434083879a6398aafd54d9e73"
}

protocol WeatherServiceType {
    func fetchWeather(with params: [String: Any]) -> Observable<Weather>
}

struct WeatherService: WeatherServiceType {
    func fetchWeather(with params: [String : Any]) -> Observable<Weather> {
        return Observable.just(Weather())
    }
}
