//
//  HomeViewModel.swift
//  ResturantReminder
//
//  Created by Faraz on 12/21/21.
//

import UIKit
import FirebaseStorage

class HomeViewModel {
    
    func fetchResturant(userID: String, completion: @escaping ([ResturantModel]?, String?)->Void) {
        FirebaseManager.shared.fetchResturant(userID: userID) { model, error  in
            completion(model, error)
        }
    }
    
    func fetchRestaurantImage(restaurantID: String, completion: @escaping ((UIImage?, String?)-> Void)) {
        let imageRef = Storage.storage().reference().child("\(AppDefaults.currentUser?.userID ?? "")/\(restaurantID)/image.jpg")
        StorageService.getImage(reference: imageRef, completion: completion)
    }
    
    func fetchProfilePicture(completion: @escaping ((UIImage?, String?)-> Void)) {
        let imageRef = Storage.storage().reference().child("\(AppDefaults.currentUser?.userID ?? "")/profilePic/image.jpg")
        StorageService.getImage(reference: imageRef, completion: completion)
    }
    
    func fetchSettingsData(completion: @escaping ((SettingsModel?, String?)->Void)) {
        FirebaseManager.shared.fetchSettingsData(completion: completion)
    }
    
    func addTodayNotification(userID: String, date: String, count: Int) {
        FirebaseManager.shared.addTodayNotification(userID: userID, date: date, count: count)
    }
    
    func fetchTodayNotification(userID: String, date: String, completion: @escaping ([String : Int]?) -> Void) {
        FirebaseManager.shared.fetchTodayNotifications(userID: userID, date: date, completion: completion)
    }
    
    func removeNumOfNotifications(userID: String) {
        FirebaseManager.shared.removeNumOfNotifications(userID: userID)
    }
}
