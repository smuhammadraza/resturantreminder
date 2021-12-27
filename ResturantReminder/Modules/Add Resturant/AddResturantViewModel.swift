//
//  AddResturantViewModel.swift
//  ResturantReminder
//
//  Created by Faraz on 12/20/21.
//

import Foundation
import GooglePlaces

class AddResturantViewModel {
    
    private var placesClient: GMSPlacesClient = GMSPlacesClient.shared()

    func addResturant(userID: String, name: String, address: String, phone: String, rating: Double, url: String, notes: String, categories: [String]) {
        FirebaseManager.shared.addRestaurant(userID: userID, name: name, address: address, phone: phone, rating: rating, url: url, notes: notes, categories: categories)
    }
    
    func addCategories(categories: [String]) {
        FirebaseManager.shared.addCategories(categories: categories)
    }
    
    func fetchPlacesAutoComplete(text: String, completion: @escaping ((String?, String?)-> Void)) {
        let placeFields: GMSPlaceField = [.name, .formattedAddress]
        placesClient.findAutocompletePredictions(fromQuery: text, filter: nil, sessionToken: nil) { (placesPrediction, error) in
//            guard let self = self else { return }
            
            guard let place = placesPrediction else {
                if let error = error {
                    completion(nil, error.localizedDescription)
                }
                return
            }
            print(place.first?.attributedFullText.string)
            completion(place.first?.attributedFullText.string, nil)
        }
//        placesClient.findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: placeFields) { [weak self] (placesLikelihoods, error) in
//            guard let self = self else { return }
//
//            guard let place = placesLikelihoods?.first?.place else {
//              completion(nil)
//              return
//            }
//            completion(place.name)
//        }
    }
}
