//
//  RequestRepresentable.swift
//  WeatherApp
//
//  Created by Liyu Wang on 27/7/20.
//  Copyright © 2020 Liyu Wang. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
    case DELETE
    case PUT
}

protocol JSONConvertible: Encodable {
    func jsonData(using encoder: JSONEncoder) throws -> Data
}

extension JSONConvertible where Self: Encodable {
    func jsonData(using encoder: JSONEncoder) throws -> Data {
        return try encoder.encode(self)
    }
}

enum AuthMethod {
    case none
    case urlParams([String: Any])
}

protocol RequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var urlParameters: [String: Any]? { get }
    var payload: JSONConvertible? { get }
    var auth: AuthMethod? { get }
    func toURLRequst() throws -> URLRequest
}

extension RequestConvertible {
    var urlParameters: [String: Any]? {
        return nil
    }

    var payload: JSONConvertible? {
        return nil
    }

    var auth: AuthMethod? {
        return .urlParams([
            "appid": WebServiceConstants.secretKey,
            "units": WebServiceConstants.units
        ])
    }

    func toURLRequst() throws -> URLRequest {
        guard
            let baseURL = URL(string: WebServiceConstants.baseURL),
            let urlComponents = NSURLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: true)
            else { throw WebServiceError.invalidUrl(url: WebServiceConstants.baseURL) }

        if let params = urlParameters {
            urlComponents.queryItems = params.map { URLQueryItem(name: $0, value: String(describing: $1)) }
        }

        if let auth = auth, case .urlParams(let params) = auth {
            if urlComponents.queryItems == nil {
                urlComponents.queryItems = params.map { URLQueryItem(name: $0, value: String(describing: $1)) }
            } else {
                let queryItems = params.map { URLQueryItem(name: $0, value: String(describing: $1)) }
                queryItems.forEach { urlComponents.queryItems?.append($0) }
            }
        }

        guard let url = urlComponents.url else {
            throw WebServiceError.invalidUrl(url: WebServiceConstants.baseURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if request.value(forHTTPHeaderField: "Content-Type") == nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        if let payload = payload {
            do {
                request.httpBody = try payload.jsonData(using: JSONEncoder())
            } catch {
                throw WebServiceError.payloadEncodingError(error: error)
            }
        }
        return request
    }
}
