//
//  HomeViewModel.swift
//  ResturantReminder
//
//  Created by Faraz on 12/21/21.
//

import Foundation

class HomeViewModel {
    
    func fetchResturant(userID: String, resturantID: String, completion: @escaping ([ResturantModel]?, String?)->Void) {
        FirebaseManager.shared.fetchResturant(userID: userID, resturantID: resturantID) { model, error  in
            completion(model, error)
        }
    }
}
