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

    var viewModel: WeatherListViewModelType! = WeatherListViewModel()

    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
        bindViews()
        viewModel.fetchAllLocalWeathers()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

private extension WeatherListViewController {
    func configViews() {
        navigationItem.title = "Recent Search"
        
        tableView.rx.setDelegate(self)
            .disposed(by: bag)
    }

    func bindViews() {
        viewModel.weatherListObservable
            .bind(to: tableView.rx.items(cellIdentifier: "WeatherTableViewCell", cellType: UITableViewCell.self)) { (row, weather, cell) in
                cell.textLabel?.text = "\(weather.name), \(weather.country)"
            }
            .disposed(by: bag)

        tableView.rx.modelDeleted(Weather.self)
            .subscribe(
                onNext: { [weak self] w in
                    self?.viewModel.delete(weather: w)
                }
            )
            .disposed(by: bag)

        tableView.rx.modelSelected(Weather.self)
            .subscribe(
                onNext: { [weak self] w in
                    guard let self = self else { return }
                    let mapVC = MapViewController.instantiate()
                    mapVC.viewModel = MapViewModel(weather: w)
                    self.navigationController?.pushViewController(mapVC, animated: true)
                }
            )
            .disposed(by: bag)
    }
}

extension WeatherListViewController: UITableViewDelegate {

}
