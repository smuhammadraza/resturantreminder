//
//  AddResturantViewModel.swift
//  ResturantReminder
//
//  Created by Faraz on 12/20/21.
//

import Foundation

class AddResturantViewModel {
    
    func addResturant(userID: String, name: String, address: String, phone: String, rating: Double, url: String, notes: String, categories: [String]) {
        FirebaseManager.shared.addRestaurant(userID: userID, name: name, address: address, phone: phone, rating: rating, url: url, notes: notes, categories: categories)
    }
    
    func addMeta(categories: [String]) {
        FirebaseManager.shared.addMeta(categories: categories)
    }
    
}
