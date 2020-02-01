//
//  String+ModificationExtensions.swift
//  WeatherApp
//
//  Created by Liyu Wang on 2/2/20.
//  Copyright © 2020 Liyu Wang. All rights reserved.
//

import Foundation

extension String {
    func trimed() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
