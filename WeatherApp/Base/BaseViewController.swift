//
//  BaseViewController.swift
//  WeatherApp
//
//  Created by Liyu Wang on 6/1/20.
//  Copyright © 2020 Liyu Wang. All rights reserved.
//

import UIKit

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

class BaseViewController: UIViewController, Storyboarded {
    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
        doBinding()
    }

    func configViews() {

    }

    func doBinding() {

    }
}
