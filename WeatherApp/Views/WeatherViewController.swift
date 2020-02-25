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

class WeatherViewController: UIViewController, ActivityIndicatable {
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
    @IBOutlet weak var historyButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!

    var viewModel: WeatherViewModelType! = WeatherViewModel()

    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViews()
        viewModel.fetchMostRecentWeather(skipLocal: false)
    }
}

extension WeatherViewController: LoadingStatusObserver {
    var loadingStatusEmitable: LoadingStatusEmitable {
        viewModel
    }
}

extension WeatherViewController: ErrorObserver {
    var errorEmitable: ErrorEmitable {
        viewModel
    }
}

private extension WeatherViewController {
    func bindViews() {
        bindLoadingStatus()
        bindError()

        historyButton.rx.tap
            .subscribe(
                onNext: { [weak self] _ in
                    guard let self = self else { return }
                    let weatherListVC = WeatherListViewController.instantiate()
                    weatherListVC.weatherQueryable = self.viewModel
                    self.navigationController?.pushViewController(weatherListVC, animated: true)
                }
            )
            .disposed(by: bag)

        refreshButton.rx.tap
            .subscribe(
                onNext: { [weak self] _  in
                    guard let self = self else { return }
                    self.viewModel.fetchMostRecentWeather(skipLocal: true)
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

        let weatherDriver = viewModel.weatherDriver

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
                    if weather == Weather.emptyWeather {
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
