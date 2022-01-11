//
//  LocationManager.swift
//  ResturantReminder
//
//  Created by Faraz on 1/2/22.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    
    var locationManager = CLLocationManager()
    static let shared = LocationManager()
    private override init() {
        super.init()
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
    
    func monitorRegionAtLocation(center: CLLocationCoordinate2D, identifier: String) {
        
        var restaurantName = ""
        FirebaseManager.shared.fetchSingleResturant(userID: UserModel.shared.userID, resturantID: identifier) { (singleRestaurant, _) in
            if let singleRestaurant = singleRestaurant {
                restaurantName = singleRestaurant.name ?? "Restaurant"
            }
            // Make sure the devices supports region monitoring.
            if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
                // Register the region.
                let maxDistance = self.locationManager.maximumRegionMonitoringDistance
                let max: CLLocationDistance = 2
                let region = CLCircularRegion(center: center,
                                              radius: max, identifier: identifier)
                region.notifyOnEntry = true
                region.notifyOnExit = true
                Snackbar.showSnackbar(message: "Reminder added for \(restaurantName).", duration: .middle)
                self.locationManager.startMonitoring(for: region)
            }
        }
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringVisits()
        locationManager.startMonitoringSignificantLocationChanges()
    }
}

//extension LocationManager: 
