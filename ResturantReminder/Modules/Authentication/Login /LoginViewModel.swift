//
//  LoginViewModel.swift
//  ResturantReminder
//
//  Created by Faraz on 12/19/21.
//

import Foundation
import FirebaseAuth

class LoginViewModel {
    func loginUser(email: String, password: String, completion: @escaping ((AuthDataResult?, Error?) -> Void)) {
        Auth.auth().signIn(withEmail: email, password: password) {  (authResult, error) in
            completion(authResult, error)
        }
    }
}
