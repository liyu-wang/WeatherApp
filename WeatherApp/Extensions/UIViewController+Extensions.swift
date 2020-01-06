//
//  UIViewController+Extensions.swift
//  WeatherApp
//
//  Created by Wang, Liyu on 6/1/20.
//  Copyright © 2020 Liyu Wang. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(for error: Error, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: "Error",
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { action in
            completion?()
        }
        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }
}
