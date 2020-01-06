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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
