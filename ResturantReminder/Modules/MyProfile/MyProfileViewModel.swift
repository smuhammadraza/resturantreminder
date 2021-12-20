//
//  MyProfileViewModel.swift
//  ResturantReminder
//
//  Created by Faraz on 12/20/21.
//

import Foundation

class MyProfileViewModel {
    
    func addAbout(aboutText: String) {
        FirebaseManager.shared.addUserAbout(text: aboutText)
        UserModel.shared.about = aboutText
        AppDefaults.currentUser?.about = aboutText
    }
    
    func fetchAbout(completion: @escaping (String?) -> Void) {
        FirebaseManager.shared.fetchUserAbout { error in
            completion(error)
        }
    }
    
    func updateName(name: String) {
        FirebaseManager.shared.updateName(name: name)
        UserModel.shared.fullName = name
        AppDefaults.currentUser?.fullName = name
    }
}
