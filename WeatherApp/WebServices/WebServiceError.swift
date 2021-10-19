//
//  WebServiceError.swift
//  WeatherApp
//
//  Created by Liyu Wang on 1/1/20.
//  Copyright © 2020 Liyu Wang. All rights reserved.
//

import Foundation

enum WebServiceError: Error {
    case invalidUrl(url: String)
    case urlParametersEncodingError(error: Error)
    case payloadEncodingError(error: Error)
    case responseDecodingError(error: Error)
    case unacceptableStatusCode(code: Int, message: String)
}

extension WebServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidUrl(let url):
            return "Invalid url \(url)."
        case .urlParametersEncodingError(let error):
            return "Failed to encode the url parameters: \(error)"
        case .payloadEncodingError(let error):
            return "Failed to encode the payload: \(error)"
        case .responseDecodingError(let error):
            return "Failed to decode the response: \(error)"
        case .unacceptableStatusCode(let code, let message):
            return "unacceptable status code: \(code), message: \(message)."
        }
    }
}
