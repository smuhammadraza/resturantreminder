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
    
    func fetchPlacesAutoComplete(text: String, completion: @escaping (([GMSAutocompletePrediction]?, String?)-> Void)) {
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
            completion(place, nil)
        }
    }
    
    func fetchPlaceDetails(with placeID: String, completion: @escaping (CLLocationCoordinate2D? , Error?) -> Void) {
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.coordinate.rawValue) |
                                                    UInt(GMSPlaceField.coordinate.rawValue))

        placesClient.fetchPlace(fromPlaceID: placeID, placeFields: fields, sessionToken: nil, callback: {
          (place: GMSPlace?, error: Error?) in
          if let error = error {
            print("\(error.localizedDescription)")
            completion(nil, error)
            return
          }
          if let place = place {
            completion(place.coordinate, nil)
            print("The selected place is: \(place.name)")
          }
        })
    }
}
