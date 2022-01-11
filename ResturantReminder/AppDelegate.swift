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
import CoreLocation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
//        LocationManager.shared.locationManager.delegate = self
        if let launchOptions = launchOptions {
            if launchOptions.keys.contains(.location) {
//                LocationManager.shared.locationManager.delegate = self
            }
        }
        
        FirebaseApp.configure()
        setupNotification(application)
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
    
    
    // MARK: - SETUP NOTIFICATION
    private func setupNotification(_ application: UIApplication) {
           //MARK: - Firebase Push Notification
           if #available(iOS 10.0, *) {
               // For iOS 10 display notification (sent via APNS)
               UNUserNotificationCenter.current().delegate = self
               
               let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
               UNUserNotificationCenter.current().requestAuthorization(
                   options: authOptions,
                   completionHandler: {_, _ in })
           } else {
               let settings: UIUserNotificationSettings =
                   UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
               application.registerUserNotificationSettings(settings)
           }
           application.registerForRemoteNotifications()
       }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    }
}

//extension AppDelegate: CLLocationManagerDelegate {
//
//    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
//        if let region = region as? CLCircularRegion {
//            let identifier = region.identifier
//            NotificationManager.shared.triggerReminderNotification(identifier: identifier)
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
//        if let region = region as? CLCircularRegion {
//            let identifier = region.identifier
//            NotificationManager.shared.triggerReminderNotification(identifier: identifier)
//        }
//    }
//}
