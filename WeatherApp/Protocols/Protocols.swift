//
//  Protocols.swift
//  WeatherApp
//
//  Created by Liyu Wang on 2/2/20.
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

protocol ViewConfigurable {
    func configViews()
}

extension ViewConfigurable {
    func configViews() {}
}

protocol ViewBindable {
    func bindViews()
}

extension ViewBindable {
    func bindViews() {}
}

typealias ViewController = ViewConfigurable & ViewBindable
typealias StoryboardedViewController = Storyboarded & ViewController
