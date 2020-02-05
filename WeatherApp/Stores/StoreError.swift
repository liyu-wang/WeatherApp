//
//  StoreError.swift
//  WeatherApp
//
//  Created by Wang, Liyu on 3/1/20.
//  Copyright © 2020 Liyu Wang. All rights reserved.
//

import Foundation

enum StoreError: Error {
    case failedToInitDBInstance
    case failedToWriteDB(error: Error)
    case entityWithSpecifiedIdNotExist(id: Int)
}

extension StoreError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .failedToInitDBInstance:
            return "Failed to init db instance."
        case .failedToWriteDB(let error):
            return "Failed to write db with error: \(error.localizedDescription)"
        case .entityWithSpecifiedIdNotExist(let id):
            return "Entity[\(id)] doesn't exist."
        }
    }
}
