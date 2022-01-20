//
//  AddResturantViewModel.swift
//  ResturantReminder
//
//  Created by Faraz on 12/20/21.
//

import Foundation
import GooglePlaces
import FirebaseDatabase

class AddResturantViewModel {
    
    private var placesClient: GMSPlacesClient = GMSPlacesClient.shared()
    private let networkObj = AddRestaurantNetwork()

    func addResturant(userID: String, name: String, address: String, phone: String, rating: Double, url: String, notes: String, categories: [String], completion: @escaping (Error?, DatabaseReference) -> Void) {
        FirebaseManager.shared.addRestaurant(userID: userID, name: name, address: address, phone: phone, rating: rating, url: url, notes: notes, categories: categories, completion: completion)
    }
    
    func addCategories(categories: [String]) {
        FirebaseManager.shared.addCategories(categories: categories)
    }
    
    func fetchCategories(completion: @escaping (([String]?) -> Void)) {
        FirebaseManager.shared.fetchCategories { fetchedCategories in
            completion(fetchedCategories)
        }
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
    
    func fetchPlaceDetails(with placeID: String, completion: @escaping (CLLocationCoordinate2D?, UIImage? , Error?) -> Void) {
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.coordinate.rawValue) |
                                                    UInt(GMSPlaceField.coordinate.rawValue))
        var image: UIImage?
        placesClient.fetchPlace(fromPlaceID: placeID, placeFields: fields, sessionToken: nil, callback: {
          (place: GMSPlace?, error: Error?) in
          if let error = error {
            print("\(error.localizedDescription)")
            completion(nil, nil, error)
            return
          }
          if let place = place {
            let photoMetadata: GMSPlacePhotoMetadata = place.photos![0]
            self.placesClient.loadPlacePhoto(photoMetadata) { (photo, error) in
                if let error = error {
                    // TODO: Handle the error.
                    print("Error loading photo metadata: \(error.localizedDescription)")
                    return
                } else {
                    // Display the first image and its attributions.
                    completion(place.coordinate, image, nil)
                    print(photoMetadata.attributions)
                }
            }
            completion(place.coordinate, nil, nil)
            print("The selected place is: \(place.name)")
          }
        })
    }
    
    func getScannedData(url: String, completion: @escaping ((String?, String?) -> Void)) {
        networkObj.getScannedData(url: url, completion: completion)
    }
}
