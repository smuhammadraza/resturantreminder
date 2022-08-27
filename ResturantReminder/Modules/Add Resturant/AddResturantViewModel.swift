//
//  AddResturantViewModel.swift
//  ResturantReminder
//
//  Created by Faraz on 12/20/21.
//

import Foundation
import GooglePlaces
import FirebaseDatabase
import FirebaseStorage

class AddResturantViewModel {
    
    private var placesClient: GMSPlacesClient = GMSPlacesClient.shared()
    private let networkObj = AddRestaurantNetwork()

    func addResturant(userID: String,
                      name: String,
                      address: String,
                      phone: String,
                      rating: Double,
                      url: String,
                      notes: String,
                      categories: [String],
                      latitude: String,
                      longitude: String,
                      selectedRestaurantImage: UIImage?,
                      completion: @escaping (Error?, DatabaseReference) -> Void) {
        FirebaseManager.shared.addRestaurant(userID: userID,
                                             name: name,
                                             address: address,
                                             phone: phone,
                                             rating: rating,
                                             url: url,
                                             notes: notes,
                                             categories: categories,
                                             latitude: latitude,
                                             longitude: longitude,
                                             completion: { (error, databaseRef) in
            if let error = error {
                completion(error, databaseRef)
            } else {
                let dbURL = databaseRef.url
                if let index = dbURL.range(of: "/", options: .backwards)?.upperBound {
                    let restaurantNodeString = dbURL.substring(from: index)
                    if !restaurantNodeString.isEmpty {
                        let resturantImage = selectedRestaurantImage ?? UIImage(named: "NoImage-Placeholder")!
                        self.uploadRestaurantImage(image: resturantImage,
                                                   restaurantID: restaurantNodeString, completion: {
                            completion(error, databaseRef)
                        })
                    } else { completion(error, databaseRef) }
                } else { completion(error, databaseRef) }
            }
        })
    }
    
    func editResturant(restaurantID: String, userID: String, name: String, address: String, phone: String, rating: Double, url: String, notes: String, categories: [String], latitude: String, longitude: String, completion: @escaping (Error?, DatabaseReference) -> Void) {
        FirebaseManager.shared.editRestaurant(restaurantID: restaurantID, userID: userID, name: name, address: address, phone: phone, rating: rating, url: url, notes: notes, categories: categories, latitude: latitude, longitude: longitude, completion: completion)
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
        let filter = GMSAutocompleteFilter()
        filter.countries = ["us"]
        placesClient.findAutocompletePredictions(fromQuery: text, filter: filter, sessionToken: nil) { (placesPrediction, error) in
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
                                                    UInt(GMSPlaceField.coordinate.rawValue) | UInt(GMSPlaceField.photos.rawValue))
//        var image: UIImage?
        placesClient.fetchPlace(fromPlaceID: placeID, placeFields: fields, sessionToken: nil, callback: {
          (place: GMSPlace?, error: Error?) in
          if let error = error {
            print("\(error.localizedDescription)")
            completion(nil, nil, error)
            return
          }
          if let place = place {
            if let photo = place.photos?[0] {
                let photoMetadata: GMSPlacePhotoMetadata = photo
                self.placesClient.loadPlacePhoto(photoMetadata) { (photo, error) in
                    if let error = error {
                        // TODO: Handle the error.
                        print("Error loading photo metadata: \(error.localizedDescription)")
                        return
                    } else {
                        // Display the first image and its attributions.
                        completion(place.coordinate, photo, nil)
                        print(photoMetadata.attributions)
                    }
                }
                completion(place.coordinate, nil, nil)
                print("The selected place is: \(place.name ?? "")")
            } else {
                completion(place.coordinate, nil, nil)
            }
          }
        })
    }
    
    func getScannedData(url: String, completion: @escaping ((String?, String?) -> Void)) {
        networkObj.getScannedData(url: url, completion: completion)
    }
    
    func uploadRestaurantImage(image: UIImage, restaurantID: String, completion: @escaping ()->()) {
        let imageRef = Storage.storage().reference().child("\(AppDefaults.currentUser?.userID ?? "")/\(restaurantID)/image.jpg")
        StorageService.uploadImage(image, at: imageRef) { (_) in
            print("🔥  ----- Image Downloaded for added restaurant ------- 🔥")
            completion()
        }
    }
    
    
    
}
