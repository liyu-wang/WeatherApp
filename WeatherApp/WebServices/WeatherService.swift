//
//  WeatherWebService.swift
//  WeatherApp
//
//  Created by Liyu Wang on 1/1/20.
//  Copyright © 2020 Liyu Wang. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct WebServiceConstants {
    static let baseURL = "https://api.openweathermap.org/data/2.5"
    static let iconURL = "https://openweathermap.org/img/wn/%@@2x.png"
    static let secretKey = "<#api key#>"
    static let units = "metric"
    static let validStatusCodes = 200..<300
}

protocol WeatherServiceType {
    func fetchWeather(byCityName name: String) -> Single<Weather>
    func fetchWeather(byZip zip: String, countryCode: String) -> Single<Weather>
    func fetchWeather(byLatitude latitude: Double, longitude: Double) -> Single<Weather>
    func fetchWeather(byId id: Int) -> Single<Weather>
}

struct WeatherService: WeatherServiceType {
    func fetchWeather(byCityName name: String) -> Single<Weather> {
        return fetchWeather(with: ["q": name])
    }

    func fetchWeather(byZip zip: String, countryCode: String) -> Single<Weather> {
        return fetchWeather(with: ["zip": "\(zip),\(countryCode)"])
    }

    func fetchWeather(byLatitude latitude: Double, longitude: Double) -> Single<Weather> {
        return fetchWeather(with: ["lat": latitude, "lon": longitude])
    }

    func fetchWeather(byId id: Int) -> Single<Weather> {
        return fetchWeather(with: ["id": id])
    }
}

private extension WeatherService {
    func fetchWeather(with params: [String : Any]) -> Single<Weather> {
        let request: URLRequest
        do {
            request = try makeGetRequest(path: "weather", params: params)
        } catch {
            return Single.error(error)
        }
        return URLSession.shared.rx.response(request: request)
            .debug("GET /weather")
            .map { response, data -> Weather in
                guard WebServiceConstants.validStatusCodes ~= response.statusCode else {
                    let errorMessage: WeatherServiceErrorMessage
                    do {
                        errorMessage = try JSONDecoder().decode(WeatherServiceErrorMessage.self, from: data)
                    } catch {
                        throw WebServiceError.responseDecodingError(error: error)
                    }
                    throw WebServiceError.unacceptableStatusCode(code: response.statusCode, message: errorMessage.message)
                }
                do {
                    let weatherData = try JSONDecoder().decode(WeatherServiceData.self, from: data)
                    return Weather(from: weatherData)
                } catch {
                    throw WebServiceError.responseDecodingError(error: error)
                }
            }
            .asSingle()
    }

    func makeGetRequest(path: String, params: [String: Any]) throws -> URLRequest {
        guard let url = URL(string: WebServiceConstants.baseURL),
            let urlComponents = NSURLComponents(url: url.appendingPathComponent(path), resolvingAgainstBaseURL: true) else {
            throw WebServiceError.invalidUrl(url: WebServiceConstants.baseURL)
        }
        urlComponents.queryItems = params.map { URLQueryItem(name: $0, value: String(describing: $1)) }
        urlComponents.queryItems?.append(URLQueryItem(name: "appid", value: WebServiceConstants.secretKey))
        urlComponents.queryItems?.append(URLQueryItem(name: "units", value: WebServiceConstants.units))

        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}
