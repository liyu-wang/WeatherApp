//
//  Observable+Extension.swift
//  WeatherApp
//
//  Created by Liyu Wang on 27/9/20.
//  Copyright © 2020 Liyu Wang. All rights reserved.
//

import Foundation
import RxSwift

extension Observable where Element: Sequence, Element.Element: DomainModelConvertibleType {
    func mapToDomainModels() -> Observable<[Element.Element.DomainModelType]> {
        return map { sequence -> [Element.Element.DomainModelType] in
            return sequence.mapToDomainModels()
        }
    }
}

extension Sequence where Element: DomainModelConvertibleType {
    func mapToDomainModels() -> [Element.DomainModelType] {
        return map { $0.asDomainModel() }
    }
}
