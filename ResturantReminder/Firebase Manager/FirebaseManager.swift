//
//  FirebaseManager.swift
//  ResturantReminder
//
//  Created by Faraz on 12/20/21.
//

import Foundation
import FirebaseDatabase
import UIKit

class FirebaseManager {
    
    static let shared = FirebaseManager()
    private init() {}
    
    var ref: DatabaseReference!

    func addUser(userID: String, fullName: String, postalCode: String, email: String) {
        ref = Database.database().reference()
        self.ref.child("users").child(userID).setValue(["fullName": fullName, "postalCode": postalCode, "email": email, "userID": userID])
    }
    
    func fetchUser(userID: String, completion: @escaping (String?)->Void) {
        ref = Database.database().reference()
        ref.child("users").child(userID).observeSingleEvent(of: .value, with: { snapshot in
            let value = snapshot.value as? NSDictionary
            UserModel.shared.fullName = value?["fullName"] as? String ?? ""
            UserModel.shared.email = value?["email"] as? String ?? ""
            UserModel.shared.postalCode = value?["postalCode"] as? String ?? ""
            UserModel.shared.userID = value?["userID"] as? String ?? ""
            UserModel.shared.about = value?["about"] as? String
            completion(nil)
        }) { error in
            print(error.localizedDescription)
            completion(error.localizedDescription)
        }
    }
    
    func addRestaurant(userID: String, name: String, address: String, phone: String, rating: Double, url: String, notes: String, categories: [String]) {
        ref = Database.database().reference()
        self.ref.child("users").child(userID).child("restaurants").childByAutoId().setValue(["name": name, "address": address, "phone": phone, "rating": rating, "url": url, "notes": notes, "categories": categories])
    }
    
    func fetchResturant(userID: String, resturantID: String, completion: @escaping ([ResturantModel]?, String?)->Void) {
        ref = Database.database().reference()
//        ref.child("users").child(userID).child("restaurants")
        ref.child("users").child(userID).child("restaurants").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? NSDictionary else {
                completion(nil, "No Restaurants Found")
                return
            }
            do {
                var restaurantModel = [ResturantModel]()
                for value1 in value {
                    let json = try JSONSerialization.data(withJSONObject: value1.value)
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    if let decodedRestaurants = try decoder.decode(ResturantModel?.self, from: json) {
                        restaurantModel.append(decodedRestaurants)
                        print(decodedRestaurants)
                    }
                }
                completion(restaurantModel, nil)
            } catch {
                print(error.localizedDescription)
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func addUserAbout(text: String) {
        ref = Database.database().reference()
        ref.child("users").child(AppDefaults.currentUser?.userID ?? "").updateChildValues(["about": text])
    }
    
    func fetchUserAbout(completion: @escaping (String?)->Void) {
        ref = Database.database().reference()
        ref.child("users").child(AppDefaults.currentUser?.userID ?? "").observeSingleEvent(of: .value, with: { snapshot in
            let value = snapshot.value as? NSDictionary
            UserModel.shared.about = value?["about"] as? String
            AppDefaults.currentUser?.about = value?["about"] as? String
            completion(nil)
        }) {
            error in
            completion(error.localizedDescription)
        }
    }
    
    func updateName(name: String) {
        ref = Database.database().reference()
        ref.child("users").child(UserModel.shared.userID).updateChildValues(["fullName": name])
    }
    
    func addCategories(categories: [String]) {
        var fetchedCategories = [String]()
        ref = Database.database().reference()
        ref.child("users").child(UserModel.shared.userID).observeSingleEvent(of: .value) { snapshot in
            let value = snapshot.value as? NSDictionary
            if let fetchedCategoriesUnwrapped = value?["categories"] as? [String] {
                fetchedCategories = categories + fetchedCategoriesUnwrapped
            } else {
                fetchedCategories = categories
            }
            let fetchedCategoriesNonRepeating = Array(Set(fetchedCategories))
            self.ref.child("users").child(UserModel.shared.userID).updateChildValues(["categories": fetchedCategoriesNonRepeating])
            UIApplication.stopActivityIndicator()
        }
    }
    
    func fetchCategories(completion: @escaping (([String]?) -> Void)) {
        ref = Database.database().reference()
        ref.child("users").child(UserModel.shared.userID).observeSingleEvent(of: .value) { snapshot in
            let value = snapshot.value as? NSDictionary
            let fetchedCategoriesUnwrapped = value?["categories"] as? [String]
            completion(fetchedCategoriesUnwrapped)
            
        }
    }
    
    func addSettingsData(postToFacebook: Bool?, postToTwitter: Bool?, alertWhenNearBy: Bool?, distance: Double?, numberOfNotifications: Int?, completion: @escaping ((Error?, DatabaseReference) -> Void)) {
        ref = Database.database().reference()
        var dict = [String: Any]()
        if let postToFacebook = postToFacebook {
            dict["facebook"] = postToFacebook
        }
        if let postToTwitter = postToTwitter {
            dict["twitter"] = postToTwitter
        }
        if let alertWhenNearBy = alertWhenNearBy {
            dict["alert"] = alertWhenNearBy
        }
        if let distance = distance {
            dict["distance"] = distance
        }
        if let numberOfNotifications = numberOfNotifications {
            dict["numberOfNotifications"] = numberOfNotifications
        }
        ref.child("users").child(UserModel.shared.userID).child("settings").updateChildValues(dict) { error, ref in
            print(ref)
            completion(error, ref)
        }
    }
    
    func fetchSettingsData(completion: @escaping (SettingsModel?, String?) -> Void) {
        ref = Database.database().reference()
        ref.child("users").child(UserModel.shared.userID).child("settings").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? NSDictionary else {
                completion(nil, "No Settings Found")
                return
            }
            do {
//                var settingsModel : SettingsModel?
//                for value1 in value {
                let json = try JSONSerialization.data(withJSONObject: value)
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    if let decodedSettings = try decoder.decode(SettingsModel?.self, from: json) {
                        completion(decodedSettings, nil)
                    }
//                }
            } catch {
                print(error.localizedDescription)
                completion(nil, error.localizedDescription)
            }
        }
    }
}
