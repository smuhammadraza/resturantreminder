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
    var locationManager = CLLocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        self.locationManager.delegate = self
        if let launchOptions = launchOptions {
            if launchOptions.keys.contains(.location) {
//                LocationManager.shared.locationManager.delegate = self
            }
        }
        application.applicationIconBadgeNumber = 0
        
        FirebaseApp.configure()
        setupNotification(application)
        setupLocationPermissions()
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
    
    private func setupLocationPermissions() {
        locationManager = CLLocationManager()
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            startUpdatingLocation()
        }
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringVisits()
        locationManager.startMonitoringSignificantLocationChanges()
        self.locationManager.delegate = self
    }
    
    func monitorRegionAtLocation(center: CLLocationCoordinate2D, identifier: String) {
        
        var restaurantName = ""
        FirebaseManager.shared.fetchSingleResturant(userID: UserModel.shared.userID, resturantID: identifier) { (singleRestaurant, _) in
            if let singleRestaurant = singleRestaurant {
                restaurantName = singleRestaurant.name ?? "Restaurant"
            }
            // Make sure the devices supports region monitoring.
            if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
                // Register the region.
//                let maxDistance = self.locationManager.maximumRegionMonitoringDistance
                var max: CLLocationDistance?
                if AppDefaults.distanceForRegionMonitoring != 0.0 {
                    max = AppDefaults.distanceForRegionMonitoring * 1609
                }
                let region = CLCircularRegion(center: center,
                                              radius: max ?? 200, identifier: identifier)
                region.notifyOnEntry = true
                region.notifyOnExit = true
                Snackbar.showSnackbar(message: "Reminder added for \(restaurantName).", duration: .short)
                self.locationManager.startMonitoring(for: region)
            }
        }
    }
    
    func stopRegionMonitoring(center: CLLocationCoordinate2D, identifier: String) {
        var max: CLLocationDistance?
        if AppDefaults.distanceForRegionMonitoring != 0.0 {
            max = AppDefaults.distanceForRegionMonitoring * 1609
        }
        let region = CLCircularRegion(center: center,
                                      radius: max ?? 200, identifier: identifier)
        region.notifyOnEntry = true
        region.notifyOnExit = true
        self.locationManager.stopMonitoring(for: region)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
}

extension AppDelegate: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations.first?.coordinate)
//        Snackbar.showSnackbar(message: "Your location is \(locations.first?.coordinate)", duration: .short)
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        FirebaseManager.shared.addDidEnterRegion(latitude: "\(manager.location?.coordinate.latitude ?? 0.0)", longitude: "\(manager.location?.coordinate.longitude ?? 0.0)", identifier: region.identifier)
        if let region = region as? CLCircularRegion {
            let identifier = region.identifier
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-YYYY"
            
            if AppDefaults.todayDate == dateFormatter.string(from: Date()) {
                if AppDefaults.numberOfNotifications > 0 {
                    NotificationManager.shared.triggerReminderNotification(identifier: identifier)
                    AppDefaults.numberOfNotifications -= 1
                }
            } else {
                AppDefaults.todayDate = dateFormatter.string(from: Date())
                self.fetchNotificationsCountFromSettings()
                NotificationManager.shared.triggerReminderNotification(identifier: identifier)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        FirebaseManager.shared.addDidExitRegion(latitude: "\(manager.location?.coordinate.latitude ?? 0.0)", longitude: "\(manager.location?.coordinate.longitude ?? 0.0)", identifier: region.identifier)
        if let region = region as? CLCircularRegion {
            let identifier = region.identifier
//            NotificationManager.shared.triggerReminderNotification(identifier: identifier)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        Snackbar.showSnackbar(message: "Monitoring didFailWithError: \(error.localizedDescription)", duration: .short)
        print("Monitoring didFailWithError: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        Snackbar.showSnackbar(message: "Monitoring monitoringDidFailFor: \(error.localizedDescription)", duration: .short)
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        Snackbar.showSnackbar(message: "Monitoring successfully started!", duration: .short)
    }
}

extension AppDelegate {
    
    //MARK: - UPDATE NOTIFICATIONS COUNT
    
    private func fetchNotificationsCountFromSettings() {
        self.fetchSettingsData { data, errorMsg in
            if let errorMsg = errorMsg {
                Snackbar.showSnackbar(message: errorMsg, duration: .middle)
            }
            if let data = data {
                guard let numberOfNotif = data.numberOfNotifications else { return }
                AppDefaults.numberOfNotifications = numberOfNotif
            }
        }
    }
    
    func fetchSettingsData(completion: @escaping ((SettingsModel?, String?)->Void)) {
        FirebaseManager.shared.fetchSettingsData(completion: completion)
    }

}
