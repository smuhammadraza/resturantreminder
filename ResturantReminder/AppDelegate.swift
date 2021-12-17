//
//  AppDelegate.swift
//  ResturantReminder
//
//  Created by Mehdi Haider on 06/12/2021.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        Bootstrapper.initialize()
        return true
    }


}

