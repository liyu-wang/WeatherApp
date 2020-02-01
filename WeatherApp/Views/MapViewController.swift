//
//  MapViewController.swift
//  WeatherApp
//
//  Created by Liyu Wang on 6/1/20.
//  Copyright © 2020 Liyu Wang. All rights reserved.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa

class MapViewController: BaseViewController {
    @IBOutlet weak var mapView: MKMapView!
    var viewModel: MapViewModel!
    private let bag = DisposeBag()

    override func configViews() {
        navigationItem.title = "Map"
    }

    override func doBinding() {
        viewModel.weatherDriver
            .map { weather -> MKPointAnnotation in
                let annotation = MKPointAnnotation()
                annotation.title = weather.name
                annotation.subtitle = "\(weather.temperature) °C"
                annotation.coordinate = CLLocationCoordinate2D(latitude: weather.latitude,
                                                               longitude: weather.longitude)
                return annotation
            }
            .drive(
                onNext: { [weak self] annotation in
                    self?.showAnotationOnMap(annotation)
                }
            )
            .disposed(by: bag)
    }

    private func showAnotationOnMap(_ annotation: MKPointAnnotation) {
        let region = MKCoordinateRegion(
            center: annotation.coordinate,
            latitudinalMeters: CLLocationDistance(exactly: 10000)!,
            longitudinalMeters: CLLocationDistance(exactly: 10000)!)

        self.mapView.addAnnotation(annotation)
        self.mapView.setRegion(mapView.regionThatFits(region), animated: false)
    }
}
