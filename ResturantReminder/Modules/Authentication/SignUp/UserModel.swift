//
//  UserModel.swift
//  ResturantReminder
//
//  Created by Faraz on 12/20/21.
//

import Foundation

struct UserModel: Codable {
    
    static var shared = UserModel()
    private init() {}
    
    init(fullName: String, postalCode: String, email: String, userID: String) {
        self.fullName = fullName
        self.postalCode = postalCode
        self.email = email
        self.userID = userID
    }
    
    var fullName = ""
    var postalCode = ""
    var email = ""
    var userID = ""
    var about: String?
}
