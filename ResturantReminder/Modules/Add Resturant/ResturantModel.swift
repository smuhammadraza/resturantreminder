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

struct ResturantModel: Codable {
    
    private init() {}
    static var shared = ResturantModel()
    
    var name, address, phone, url, notes: String?
    var rating: Double?
    
}
