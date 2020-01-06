//
//  LocationServiceManager.swift
//  WeatherApp
//
//  Created by Wang, Liyu on 6/1/20.
//  Copyright © 2020 Liyu Wang. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift

typealias LocationServiceCallback = (_ location: CLLocation?, _ error: Error?) -> Void

enum LocaitonServiceError: Error {
    case locationServiceDisabled
    case unauthorized(CLAuthorizationStatus)
}

extension LocaitonServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .locationServiceDisabled:
            return "Location Service is disabled."
        case .unauthorized(let status):
            return "unauthorized status: \(status)"
        }
    }
}

class LocationServiceManager: NSObject {
    static let shared = LocationServiceManager()

    static func isLocationServiceEnabled() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            let authStatus = CLLocationManager.authorizationStatus()
            if authStatus == .restricted || authStatus == .denied {
                return false
            }
            return true
        } else {
            return false
        }
    }

    private let locationManager: CLLocationManager
    private var callback: LocationServiceCallback?

    override init() {
        locationManager = CLLocationManager()

        super.init()

        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.delegate = self
    }

    private func requestLocaiton(withCallback callback: @escaping LocationServiceCallback) {
        self.callback = callback

        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .notDetermined {
                self.locationManager.requestWhenInUseAuthorization()
            } else if CLLocationManager.authorizationStatus() == .denied {
                self.callback?(nil, LocaitonServiceError.unauthorized(.denied))
                self.callback = nil
            } else {
                self.locationManager.requestLocation()
            }
        } else {
            self.callback?(nil, LocaitonServiceError.locationServiceDisabled)
            self.callback = nil
        }
    }

    func fetchCurrentLocation() -> Observable<CLLocation> {
        return Observable.create { observer in
            self.requestLocaiton(withCallback: { (location, error) in
                if let err = error {
                    observer.on(.error(err))
                } else {
                    observer.on(.next(location!))
                    observer.on(.completed)
                }
            })

            return Disposables.create()
        }
    }
}

extension LocationServiceManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            if callback != nil {
                self.locationManager.requestLocation()
            }
        } else if status == .notDetermined {
            // do nothing
        } else {
            self.callback?(nil, LocaitonServiceError.unauthorized(status))
            self.callback = nil
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.callback?(locations.last, nil)
        self.callback = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.callback?(nil, error)
        self.callback = nil
    }
}

