//
//  SettingsModel.swift
//  ResturantReminder
//
//  Created by Faraz on 12/27/21.
//

import Foundation

struct SettingsModel: Codable {
    
//    private init() {}
//    static var shared = SettingsModel()
    
    let postToFacebook, postToTwitter, alertWhenNearBy: Bool?
    let distance: Double?
    let numberOfNotifications: Int?
    
    enum CodingKeys: String, CodingKey {
        case postToFacebook = "facebook"
        case postToTwitter = "twitter"
        case alertWhenNearBy = "alert"
        case distance = "distance"
        case numberOfNotifications = "numberOfNotifications"
    }
}
