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
    }
    
    func fetchAbout(completion: @escaping (String?) -> Void) {
        FirebaseManager.shared.fetchUserAbout { error in
            completion(error)
        }
    }
    
    func updateName(name: String) {
        FirebaseManager.shared.updateName(name: name)
    }
}
