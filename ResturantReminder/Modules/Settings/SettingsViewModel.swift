//
//  SettingsViewModel.swift
//  ResturantReminder
//
//  Created by Faraz on 12/23/21.
//

import Foundation
import FirebaseDatabase

class SettingsViewModel {
    
    func addCategories(categories: [String]) {
        FirebaseManager.shared.addCategories(categories: categories)
    }
    
    func fetchCategories(completion: @escaping (([String]?) -> Void)) {
        FirebaseManager.shared.fetchCategories { fetchedCategories in
            completion(fetchedCategories)
        }
    }
    
    func removeCategory(category: String) {
        FirebaseManager.shared.removeCategory(category: category)
    }
    
    func addSettingsData(postToFacebook: Bool?, postToTwitter: Bool?, alertWhenNearBy: Bool?, distance: Double?, numberOfNotifications: Int?, completion: @escaping ((Error?, DatabaseReference) -> Void)) {
        FirebaseManager.shared.addSettingsData(postToFacebook: postToFacebook, postToTwitter: postToTwitter, alertWhenNearBy: alertWhenNearBy, distance: distance, numberOfNotifications: numberOfNotifications, completion: completion)
    }
    
    func fetchSettingsData(completion: @escaping ((SettingsModel?, String?)->Void)) {
        FirebaseManager.shared.fetchSettingsData(completion: completion)
    }
    
    func addTodayNotification(userID: String, date: String, count: Int) {
        FirebaseManager.shared.addTodayNotification(userID: userID, date: date, count: count)
    }

}
