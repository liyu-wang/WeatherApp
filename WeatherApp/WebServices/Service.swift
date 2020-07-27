//
//  Service.swift
//  WeatherApp
//
//  Created by Liyu Wang on 24/7/20.
//  Copyright © 2020 Liyu Wang. All rights reserved.
//

import Foundation
import RxSwift

enum HTTPMethod: String {
    case GET
    case POST
    case DELETE
    case PUT
}

typealias URLParametersRepresentable = JSONRepreseentable
typealias PayloadRepresentable = JSONRepreseentable

protocol JSONRepreseentable: Encodable {
    func jsonData(using encoder: JSONEncoder) throws -> Data
    func jsonObject(using encoder: JSONEncoder) throws -> [String: Any]
}

extension JSONRepreseentable where Self: Encodable {
    func jsonData(using encoder: JSONEncoder) throws -> Data {
        return try encoder.encode(self)
    }

    func jsonObject(using encoder: JSONEncoder) throws -> [String: Any] {
        guard let jsonObj = try JSONSerialization.jsonObject(with: jsonData(using: encoder),
                                                             options: .mutableContainers) as? [String: Any] else {
            fatalError("failed to convert JSONRepreseentable to dict")
        }
        return jsonObj
    }
}

protocol RequestRepresentable {
    var method: HTTPMethod { get }
    var path: String { get }
    var urlParameters: URLParametersRepresentable? { get }
    var payload: PayloadRepresentable? { get }
}

extension RequestRepresentable {
    var urlParameters: URLParametersRepresentable? {
        return nil
    }

    var payload: PayloadRepresentable? {
        return nil
    }
}

struct WebServiceConstants {
    static let baseURL = "https://api.openweathermap.org/data/2.5"
    static let iconURL = "https://openweathermap.org/img/wn/%@@2x.png"
    static let secretKey = "<#api key#>"
    static let units = "metric"
    static let validStatusCodes = 200..<300
}

protocol ServiceType {
    associatedtype REQ: RequestRepresentable
    func makeAPICall<T: Decodable>(_ requestRepresentable: REQ, for model: T.Type) -> Single<T>
}

struct Service<REQ: RequestRepresentable>: ServiceType {
    private func urlRequest(from requestReprentable: RequestRepresentable) throws -> URLRequest {
        guard
            let baseURL = URL(string: WebServiceConstants.baseURL),
            let urlComponents = NSURLComponents(url: baseURL.appendingPathComponent(requestReprentable.path), resolvingAgainstBaseURL: true)
            else { throw WebServiceError.invalidUrl(url: WebServiceConstants.baseURL) }

        if let params = requestReprentable.urlParameters {
            do {
                let dict = try params.jsonObject(using: JSONEncoder())
                urlComponents.queryItems = dict.map { URLQueryItem(name: $0, value: String(describing: $1)) }
                urlComponents.queryItems?.append(URLQueryItem(name: "appid", value: WebServiceConstants.secretKey))
                urlComponents.queryItems?.append(URLQueryItem(name: "units", value: WebServiceConstants.units))
            } catch {
                throw WebServiceError.urlParametersEncodingError(error: error)
            }
        }

        guard let url = urlComponents.url else {
            throw WebServiceError.invalidUrl(url: WebServiceConstants.baseURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = requestReprentable.method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if let payload = requestReprentable.payload {
            do {
                request.httpBody = try payload.jsonData(using: JSONEncoder())
            } catch {
                throw WebServiceError.payloadEncodingError(error: error)
            }
        }
        return request
    }

    func makeAPICall<T: Decodable>(_ requestRepresentable: REQ, for model: T.Type) -> Single<T> {
        let request: URLRequest
        do {
            request = try urlRequest(from: requestRepresentable)
        } catch {
            return Single.error(error)
        }

        return URLSession.shared.rx
            .response(request: request)
            .map { response, data -> T in
                guard 200..<300 ~= response.statusCode else {
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
