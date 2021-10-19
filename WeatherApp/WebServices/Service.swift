//
//  Service.swift
//  WeatherApp
//
//  Created by Liyu Wang on 24/7/20.
//  Copyright © 2020 Liyu Wang. All rights reserved.
//

import Foundation
import RxSwift

struct WebServiceConstants {
    static let baseURL = "https://api.openweathermap.org/data/2.5"
    static let iconURL = "https://openweathermap.org/img/wn/%@@2x.png"
    static let secretKey = "<#api key#>"
    static let units = "metric"
    static let validStatusCodes = 200..<300
}

protocol ServiceType {
    associatedtype RC: RequestConvertible
    func makeAPICall<T: Decodable>(_ requestConvertible: RC, for model: T.Type) -> Single<T>
}

struct Service<RC: RequestConvertible>: ServiceType {

    func makeAPICall<T: Decodable>(_ requestConvertible: RC, for model: T.Type) -> Single<T> {
        let request: URLRequest
        do {
            request = try requestConvertible.toURLRequst()
        } catch {
            return Single.error(error)
        }

        return URLSession.shared.rx
            .response(request: request)
            .map { response, data -> T in
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
                    let model = try JSONDecoder().decode(T.self, from: data)
                    return model
                } catch {
                    throw WebServiceError.responseDecodingError(error: error)
                }
            }
            .asSingle()
    }
}
