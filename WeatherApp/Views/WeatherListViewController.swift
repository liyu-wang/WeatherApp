//
//  WeatherListViewController.swift
//  WeatherApp
//
//  Created by Liyu Wang on 5/1/20.
//  Copyright © 2020 Liyu Wang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class WeatherListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    private var viewModel: WeatherListViewModel = WeatherListViewModel()
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
        doBinding()
        viewModel.fetchAllLocalWeathers()
    }
}

private extension WeatherListViewController {
    func configViews() {
        navigationItem.title = "Recent Search"
        
        tableView.rx.setDelegate(self)
            .disposed(by: bag)
    }

    func doBinding() {
        self.viewModel.weatherListObservable
            .bind(to: tableView.rx.items(cellIdentifier: "WeatherTableViewCell", cellType: UITableViewCell.self)) { (row, weather, cell) in
                cell.textLabel?.text = weather.name
            }
            .disposed(by: bag)

        self.tableView.rx.modelDeleted(Weather.self)
            .subscribe(
                onNext: { [weak self] w in
                    self?.viewModel.delete(weather: w)
                }
            )
            .disposed(by: bag)
    }
}

extension WeatherListViewController: UITableViewDelegate {

}
