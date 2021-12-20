//
//  FirebaseManager.swift
//  ResturantReminder
//
//  Created by Faraz on 12/20/21.
//

import Foundation
import FirebaseDatabase

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
    
    func addRestaurant(userID: String, name: String, address: String, phone: String, url: String, notes: String, categories: [String]) {
        ref = Database.database().reference()
        self.ref.child("users").child(userID).child("restaurants").childByAutoId().setValue(["name": name, "address": address, "phone": phone, "url": url, "notes": notes, "categories": categories])
    }
    
    func fetchResturant(userID: String, resturantID: String, completion: @escaping (String?)->Void) {
        ref = Database.database().reference()
        ref.child("users").child(userID).child(resturantID).observeSingleEvent(of: .value, with: { snapshot in
            let value = snapshot.value as? NSDictionary
            ResturantModel.shared.name = value?["name"] as? String ?? ""
            ResturantModel.shared.address = value?["address"] as? String ?? ""
            ResturantModel.shared.phone = value?["phone"] as? String ?? ""
            ResturantModel.shared.url = value?["url"] as? String ?? ""
            ResturantModel.shared.notes = value?["notes"] as? String ?? ""
            completion(nil)
        }) { error in
            print(error.localizedDescription)
            completion(error.localizedDescription)
        }
    }
    
    func addUserAbout(text: String) {
        ref = Database.database().reference()
        ref.child("users").child(UserModel.shared.userID).updateChildValues(["about": text])
    }
    
    func fetchUserAbout(completion: @escaping (String?)->Void) {
        ref = Database.database().reference()
        ref.child("users").child(UserModel.shared.userID).observeSingleEvent(of: .value, with: { snapshot in
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
}
