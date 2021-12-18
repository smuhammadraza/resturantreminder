//
//  AppDelegate.swift
//  ResturantReminder
//
//  Created by Mehdi Haider on 06/12/2021.
//

import UIKit
import IQKeyboardManagerSwift
import DropDown

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        DropDown.startListeningToKeyboard()
        Bootstrapper.initialize()
        return true
    }


}

