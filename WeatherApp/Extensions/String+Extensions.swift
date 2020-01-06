//
//  String+Extensions.swift
//  WeatherApp
//
//  Created by Wang, Liyu on 6/1/20.
//  Copyright © 2020 Liyu Wang. All rights reserved.
//

import Foundation

import Foundation


extension String {
    func containsNumbers() -> Bool {
        guard rangeOfCharacter(from: .decimalDigits) != nil else {
            return false
        }
        return true
    }

    func trimed() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
