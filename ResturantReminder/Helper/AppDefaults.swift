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
    
    
    // MARK: - accessToken
    
//    public static var accessToken: String {
//        get{
//            if let token = AppDefaults.defaults.string(forKey: "accessToken") {
//                return token
//            }else{
//                return ""
//            }
//        }
//        set{
//            AppDefaults.defaults.set(newValue, forKey: "accessToken")
//
//        }
//    }
    
    
    // MARK: - FCM TOKEN
    
//    public static var fcmToken: String {
//
//        get{
//            if let token = AppDefaults.defaults.string(forKey: "FCMToken") {
//                return token
//            }else{
//                return ""
//            }
//        }
//        set{
//            AppDefaults.defaults.set(newValue, forKey: "FCMToken")
//        }
//    }
    
    // MARK: - DEVICE TOKEN
    
//    public static var deviceToken: String {
//
//        get{
//            if let token = AppDefaults.defaults.string(forKey: "deviceToken") {
//                return token
//            }else{
//                return ""
//            }
//        }
//        set{
//            AppDefaults.defaults.set(newValue, forKey: "deviceToken")
//        }
//    }
    
//    public static var deviceTokenData: Data? {
//        get{
//            if let token = AppDefaults.defaults.data(forKey: "deviceTokenData") {
//                return token
//            }else{
//                return nil
//            }
//        }
//        set{
//            AppDefaults.defaults.set(newValue, forKey: "deviceTokenData")
//        }
//    }
    
    
    // MARK: - PUSH TOKEN
    
//    public static var voipPushToken: Data? {
//        get{
//            if let token = AppDefaults.defaults.data(forKey: "voipPushToken") {
//                return token
//            }else{
//                return nil
//            }
//        }
//        set{
//            AppDefaults.defaults.set(newValue, forKey: "voipPushToken")
//        }
//    }
     
//     public static var pushToken: String {
//
//         get{
//             if let token = AppDefaults.defaults.string(forKey: "pushToken") {
//                 return token
//             }else{
//                 return ""
//             }
//         }
//         set{
//             AppDefaults.defaults.set(newValue, forKey: "pushToken")
//         }
//     }
    
    
    // MARK: - Current Chat Active Thread
    
//    public static var currentConversationSID: String 4
    
//    public static var currentChatThread: Int {
//        get {
//            AppDefaults.defaults.integer(forKey: "currentChatThread")
//        } set {
//            AppDefaults.defaults.set(newValue, forKey: "currentChatThread")
//        }
//    }
    
//    public static var currentChatIsVetProtectUser: Bool {
//        get{
//            let alreadyLogin = AppDefaults.defaults.bool(forKey: "currentChatIsVetProtectUser")
//            return alreadyLogin
//        }
//        set{
//            AppDefaults.defaults.set(newValue, forKey: "currentChatIsVetProtectUser")
//        }
//    }
    
    
    // MARK: - setCallForward
    
//    public static var setCallForward: Bool {
//        get{
//            let alreadyLogin = AppDefaults.defaults.bool(forKey: "setCallForward")
//            return alreadyLogin
//        }
//        set{
//            AppDefaults.defaults.set(newValue, forKey: "setCallForward")
//
//        }
//    }
    
    // MARK: - BACKGROUND CALL
    
//    public static var backgroundCall: String {
//        get {
//            if let token = AppDefaults.defaults.string(forKey: "backgroundCall") {
//                return token
//            }else{
//                return ""
//            }
//        } set {
//            AppDefaults.defaults.set(newValue, forKey: "backgroundCall")
//        }
//    }
    
    // MARK: - IS DEALER LOGIN
    
    public static var isUserLoggedIn: Bool {
        get{
            let alreadyLogin = AppDefaults.defaults.bool(forKey: "isUserLoggedIn")
            return alreadyLogin
        }
        set{
            AppDefaults.defaults.set(newValue, forKey: "isUserLoggedIn")
            
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
    
}
