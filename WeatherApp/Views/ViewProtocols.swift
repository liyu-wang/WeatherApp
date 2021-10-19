//
//  ViewProtocols.swift
//  WeatherApp
//
//  Created by Liyu Wang on 17/2/20.
//  Copyright © 2020 Liyu Wang. All rights reserved.
//

import UIKit
import RxSwift

// MARK: - Storyboarded

protocol Storyboarded {
    static func instantiate(storyboardName: String) -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate(storyboardName: String = "Main") -> Self {
        let id = String(describing: self)
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: id) as! Self
    }
}

extension UIViewController: Storyboarded {}

// MARK: - ActivityIndicatable

protocol ActivityIndicatable {
    var activityIndicator: UIActivityIndicatorView! { get }
}

// MARK: - DisposeBagManagedObserver

protocol DisposeBagManagedObserver {
    var bag: DisposeBag { get }
}

// MARK: - LoadingStatusObserver

protocol LoadingStatusObserver: AnyObject, DisposeBagManagedObserver {
    var loadingStatusEmitable: LoadingStatusEmitable { get }
    func bindLoadingStatus()
}

extension LoadingStatusObserver where Self: UIViewController & ActivityIndicatable {
    func bindLoadingStatus() {
        loadingStatusEmitable.isLoadingDriver
            .map { !$0 }
            .drive(activityIndicator.rx.isHidden)
            .disposed(by: bag)
    }
}

// MARK: - ErrorObserver

protocol ErrorObserver: AnyObject, DisposeBagManagedObserver {
    var errorEmitable: ErrorEmitable { get }
    func bindError()
}

extension ErrorObserver where Self: UIViewController {
    func bindError() {
        errorEmitable.errorObservable
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] error in
                    self?.showAlert(for: error)
                }
            )
            .disposed(by: bag)
    }
}
