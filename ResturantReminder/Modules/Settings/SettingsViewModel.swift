//
//  SettingsViewModel.swift
//  ResturantReminder
//
//  Created by Faraz on 12/23/21.
//

import Foundation

class SettingsViewModel {
    
    func addMeta(categories: [String]) {
        FirebaseManager.shared.addMeta(categories: categories)
    }
    
    func fetchMeta(completion: @escaping (([String]?) -> Void)) {
        FirebaseManager.shared.fetchMeta { fetchedCategories in
            completion(fetchedCategories)
        }
    }
}
