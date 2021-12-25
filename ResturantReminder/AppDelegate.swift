//
//  AppDelegate.swift
//  ResturantReminder
//
//  Created by Mehdi Haider on 06/12/2021.
//

import UIKit
import IQKeyboardManagerSwift
import DropDown
import Firebase
import FBSDKCoreKit
import GoogleSignIn
import GooglePlaces

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        FirebaseApp.configure()
        GMSPlacesClient.provideAPIKey(Constants.googleAPIKey)
        IQKeyboardManager.shared.enable = true
        DropDown.startListeningToKeyboard()
        Bootstrapper.initialize()
        return true
    }

    // MARK: - APPLICATION OPEN URL METHODS
       
       // Google and Facebook Sign in
       func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
           if url.absoluteString.contains("facebook") {
               return ApplicationDelegate.shared.application(
                   app,
                   open: url,
                   sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                   annotation: options[UIApplication.OpenURLOptionsKey.annotation]
               )
           } else {
               return GIDSignIn.sharedInstance.handle(url)
           }
       }
       
       
       private func application(application: UIApplication,
                                openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
           var _: [String: AnyObject] = [UIApplication.OpenURLOptionsKey.sourceApplication.rawValue: sourceApplication as AnyObject, UIApplication.OpenURLOptionsKey.annotation.rawValue: annotation!]
           return GIDSignIn.sharedInstance.handle(url as URL)
       }

}

