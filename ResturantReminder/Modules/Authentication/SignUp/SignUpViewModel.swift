//
//  SignUpViewModel.swift
//  ResturantReminder
//
//  Created by Faraz on 12/19/21.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class SignUpViewModel {

    func signUpUser(fullName: String, postalCode: String, email: String, password: String, completion: @escaping ((AuthDataResult?, Error?) -> Void)) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (authResult, error) in
            completion(authResult, error)
        }
    }
    
    func addUser(userID: String, fullName: String, postalCode: String, email: String) {
        FirebaseManager.shared.addUser(userID: userID, fullName: fullName, postalCode: postalCode, email: email)
    }
    
    func addSettingsData(userID: String, postToFacebook: Bool?, postToTwitter: Bool?, alertWhenNearBy: Bool?, distance: Double?, numberOfNotifications: Int?, completion: @escaping ((Error?, DatabaseReference) -> Void)) {
        FirebaseManager.shared.addSettingsData(userID: userID, postToFacebook: postToFacebook, postToTwitter: postToTwitter, alertWhenNearBy: alertWhenNearBy, distance: distance, numberOfNotifications: numberOfNotifications, completion: completion)
    }
    
}
