//
//  ResturantModel.swift
//  ResturantReminder
//
//  Created by Faraz on 12/20/21.
//

import Foundation

struct ResturantResponse: Codable {
    let userRestaurant: ResturantModel?
}

struct ResturantModel: Codable, Equatable {
    
    private init() {}
    static var shared = ResturantModel()
    
    var restaurantID: String?
    var name, address, phone, url, notes: String?
    var rating: Double?
    var categories: [String]?
    var dateAdded: Double?
    var location: Location?

    static func == (lhs: ResturantModel, rhs: ResturantModel) -> Bool {
        lhs.restaurantID == rhs.restaurantID &&
        lhs.name == rhs.name &&
        lhs.address == rhs.address &&
        lhs.phone == rhs.phone &&
        lhs.url == rhs.url &&
        lhs.notes == rhs.notes &&
        lhs.rating == rhs.rating &&
        lhs.categories == rhs.categories &&
        lhs.location == rhs.location
    }
}

struct Location: Codable, Equatable {
    var latitude: String?
    var longitude: String?

    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.latitude == rhs.latitude &&
        lhs.longitude == rhs.longitude
    }
}
