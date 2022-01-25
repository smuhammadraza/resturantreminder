//
//  SignUpViewModel.swift
//  ResturantReminder
//
//  Created by Faraz on 12/19/21.
//

import Foundation
import FirebaseAuth

class SignUpViewModel {

    func signUpUser(fullName: String, postalCode: String, email: String, password: String, completion: @escaping ((AuthDataResult?, Error?) -> Void)) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (authResult, error) in
            completion(authResult, error)
        }
    }
    
}
