//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Liyu Wang on 5/1/20.
//  Copyright © 2020 Liyu Wang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class WeatherViewController: UIViewController {
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var locationSearchButton: UIButton!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var conditionIcon: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var updateTimeLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    private let bag = DisposeBag()
    private var viewModel: WeatherViewModel! = WeatherViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        doBinding()
        viewModel.fetchMostRecentWeather()
    }
}

private extension WeatherViewController {
    func doBinding() {
        viewModel.isLoadingDriver
            .map { !$0 }
            .drive(activityIndicator.rx.isHidden)
            .disposed(by: bag)

        viewModel.errorObservable
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] error in
                    self?.showAlert(for: error)
                }
            )
            .disposed(by: bag)

        searchField.rx.controlEvent(.editingDidEndOnExit)
            .map { self.searchField.text ?? "" }
            .filter { !$0.isEmpty }
            .subscribe(
                onNext: { [weak self] text in
                    guard let self = self else { return }
                    self.viewModel.fetchWeather(text: text)
                }
            )
            .disposed(by: bag)

        locationSearchButton.rx.tap
            .subscribe(
                onNext: { [weak self] _ in
                    guard let self = self else { return }
                    self.viewModel.fetchWeatherByGPS()
                }
            ).disposed(by: bag)

        let weatherDriver = viewModel.weatherDrive

        weatherDriver
            .map { "\($0.name), \($0.country)" }
            .drive(cityNameLabel.rx.text)
            .disposed(by: bag)

        weatherDriver.map { "\($0.temperature) °C" }
            .drive(temperatureLabel.rx.text)
            .disposed(by: bag)

        weatherDriver.map { $0.condition }
            .drive(conditionLabel.rx.text)
            .disposed(by: bag)

        weatherDriver.map { "\($0.tempMin) °C" }
            .drive(minTempLabel.rx.text)
            .disposed(by: bag)

        weatherDriver.map { "\($0.tempMax) °C" }
            .drive(maxTempLabel.rx.text)
            .disposed(by: bag)

        weatherDriver.map { "\($0.humidity) %" }
            .drive(humidityLabel.rx.text)
            .disposed(by: bag)

        weatherDriver
            .drive(
                onNext: { [weak self] weather in
                    guard let self = self else { return }
                    if weather.isEmptyWeather {
                        self.updateTimeLabel.text = "n/a"
                    } else {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
                        self.updateTimeLabel.text = "\(dateFormatter.string(from: weather.timestamp ?? Date()))"
                    }
                    self.conditionIcon.kf.setImage(with: weather.iconURL)
                }
            )
            .disposed(by: bag)
    }
}
