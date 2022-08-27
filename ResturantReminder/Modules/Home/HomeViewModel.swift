//
//  HomeViewModel.swift
//  ResturantReminder
//
//  Created by Faraz on 12/21/21.
//

import UIKit
import FirebaseStorage

class HomeViewModel {

    var restaurant = [ResturantModel]()
    var categories = [String]()
    var restaurantImages = [String: UIImage]()

    var restaurantModelBasedOnCategories = [String: [ResturantModel]]()
    var restaurantImageBasedOnCategories = [String: [String: UIImage]]()
    
    func fetchResturant(userID: String, completion: @escaping ([ResturantModel]?, String?)->Void) {
        FirebaseManager.shared.fetchResturant(userID: userID) { restaurantModel, error  in
            if let restaurantModel = restaurantModel,
                restaurantModel != self.restaurant {
                self.restaurant = restaurantModel
                var categories = [String]()
                self.restaurant.forEach { object in categories.append(contentsOf: object.categories ?? []) }
                self.categories = Array(Set(categories)).sorted()
                if self.restaurant.isEmpty {
                    completion(self.restaurant, error)
                }else {
                    self.fetchRestaurantImages(completion: {
                        self.createDataModelBasedOnCategories()
                        completion(self.restaurant, error)
                    })
                }
            } else {
                completion(self.restaurant, error)
            }

        }
    }

    private func fetchRestaurantImages(completion: @escaping ()->()) {
        let group = DispatchGroup()
        for restaurant in self.restaurant {
            group.enter()
            if let restaurantID = restaurant.restaurantID {
                self.fetchRestaurantImage(restaurantID: restaurantID) { (image, _) in
                    if let image = image {
                        self.restaurantImages[restaurantID] = image
                    }
                    group.leave()
                }
            }
        }
        let work = DispatchWorkItem.init { completion() }
        group.notify(queue: .main, work: work)
    }

    private func createDataModelBasedOnCategories() {
        restaurantModelBasedOnCategories.removeAll()
        restaurantImageBasedOnCategories.removeAll()
        for category in categories {
            let restaurants = self.restaurant.filter({ $0.categories?.contains(category) ?? false })
            restaurants.forEach { categoryWiseRestaurant in
                if restaurantModelBasedOnCategories[category] == nil {
                    restaurantModelBasedOnCategories[category] = [categoryWiseRestaurant]
                } else {
                    restaurantModelBasedOnCategories[category]?.append(categoryWiseRestaurant)
                }
                let result = restaurantImages.first(where: { $0.key == (categoryWiseRestaurant.restaurantID ?? "") })
                let dict = [(result?.key ?? ""): (result?.value ?? UIImage(named: "NoImage-Placeholder")!)]
                if restaurantImageBasedOnCategories[category] == nil {
                    restaurantImageBasedOnCategories[category] = dict
                } else {
                    var existing = restaurantImageBasedOnCategories[category] ?? [:]
                    existing[(result?.key ?? "")] = (result?.value ?? UIImage(named: "NoImage-Placeholder")!)
                    restaurantImageBasedOnCategories[category] = existing
                }
            }
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
}
