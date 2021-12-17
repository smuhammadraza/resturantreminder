//
//  StoryboardInitializable.swift
//  ResturantReminder
//
//  Created by Mehdi Haider on 15/12/2021.
//

import UIKit

protocol StoryboardInitializable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardInitializable where Self: UIViewController {
    
    static var storyboardIdentifier: String {
        return String(describing: Self.self)
    }
    
    static func initFromStoryboard(name: String) -> Self {
        let storyboard = UIStoryboard(name: name, bundle: Bundle.main)
        if let controller = storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as? Self {
            return controller
        }
        fatalError("Controller didn't initialized")
    }
}
