//
//  AppDefaults.swift
//  Carzaty
//
//  Created by Raza Naqvi on 04/12/2018.
//  Copyright © 2018 Hassan. All rights reserved.
//

import Foundation

class AppDefaults {
    
    public static let defaults = UserDefaults.init()
    
    // MARK: - CLEAR ALL USER DEFAULTS
    
    public static func clearUserDefaults(){
        let dictionary = AppDefaults.defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        let dictionary2 = AppDefaults.defaults.dictionaryRepresentation()
        print("Key is \(dictionary2)")
    }
    
    // MARK: - IS USER LOGIN
    
    public static var isUserLoggedIn: Bool {
        get{
            let alreadyLogin = AppDefaults.defaults.bool(forKey: "isUserLoggedIn")
            return alreadyLogin
        }
        set{
            AppDefaults.defaults.set(newValue, forKey: "isUserLoggedIn")
            
        }
    }
    
    public static var loggedInFromFacebook: Bool {
        get{
            let facebookLogin = AppDefaults.defaults.bool(forKey: "loggedInFromFacebook")
            return facebookLogin
        }
        set{
            AppDefaults.defaults.set(newValue, forKey: "loggedInFromFacebook")
            
        }
    }
    
    public static var facebookToken: String {
        get{
            let facebookLogin = AppDefaults.defaults.string(forKey: "facebookToken")
            return facebookLogin ?? ""
        }
        set{
            AppDefaults.defaults.set(newValue, forKey: "facebookToken")
            
        }
    }
    
    public static var distanceForRegionMonitoring: Double {
        get{
            let distanceForRegionMonitoring = AppDefaults.defaults.double(forKey: "distanceForRegionMonitoring")
            return distanceForRegionMonitoring
        }
        set{
            AppDefaults.defaults.set(newValue, forKey: "distanceForRegionMonitoring")
            
        }
    }
    
    //MARK: - USER OBJECT
    
    public static var currentUser: UserModel? {
        get{
            if let data = AppDefaults.defaults.data(forKey: "CurrentUser") {
                let decoder = JSONDecoder()
                do{
                    let decoded = try decoder.decode(UserModel.self, from: data)
                    return decoded
                }catch{
                    return nil
                }
            }
            return nil
        }
        set{
            let encoder = JSONEncoder()
            do {
                let jsonData = try encoder.encode(newValue)
                AppDefaults.defaults.set(jsonData, forKey: "CurrentUser")

            }catch{
                print("Current User not save")
            }
        }
    }
    
    public static var numberOfNotifications: Int {
        get{
            let numberOfNotifications = AppDefaults.defaults.integer(forKey: "numberOfNotifications")
            return numberOfNotifications
        }
        set{
            AppDefaults.defaults.set(newValue, forKey: "numberOfNotifications")
            
        }
    }
    
    public static var todayDate: String {
        get{
            let date = AppDefaults.defaults.string(forKey: "todayDate")
            return date ?? ""
        }
        set{
            AppDefaults.defaults.set(newValue, forKey: "todayDate")
            
        }
    }
    
    public static var fromLogin: Bool {
        get{
            let value = AppDefaults.defaults.bool(forKey: "fromLogin")
            return value
        }
        set{
            AppDefaults.defaults.set(newValue, forKey: "fromLogin")
            
        }
    }
    
    public static var notifRestaurantID: String {
        get{
            let value = AppDefaults.defaults.string(forKey: "notifRestaurantID") ?? ""
            return value
        }
        set{
            AppDefaults.defaults.set(newValue, forKey: "notifRestaurantID")
            
        }
    }
}
