//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Liyu Wang on 1/1/20.
//  Copyright © 2020 Liyu Wang. All rights reserved.
//

import Foundation

struct WeatherResponseData: Decodable {
    let id: Int
    let name: String
    let dt: Int
    let sys: SysInfo
    let coord: Coordinators
    let weather: [Weather]
    let main: MainInfo

    struct SysInfo: Decodable {
        let country: String
    }

    struct Coordinators: Decodable {
        let lon: Double
        let lat: Double
    }

    struct Weather: Decodable {
        let main: String
        let icon: String
    }

    struct MainInfo: Decodable {
        let temp: Float
        let tempMin: Float
        let tempMax: Float
        let humidity: Int

        private enum CodingKeys: String, CodingKey {
            case temp
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case humidity
        }
    }
}

struct WeatherServiceErrorMessage: Decodable {
    let cod: String
    let message: String

    private enum CodingKeys: String, CodingKey {
        case cod
        case message
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            cod = try values.decode(String.self, forKey: .cod)
        } catch {
            let code = try values.decode(Int.self, forKey: .cod)
            cod = "\(code)"
        }
        message = try values.decode(String.self, forKey: .message)
    }
}
