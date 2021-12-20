//
//  ResturantModel.swift
//  ResturantReminder
//
//  Created by Faraz on 12/20/21.
//

import Foundation

struct ResturantModel: Codable {
    
    private init() {}
    static var shared = ResturantModel()
    
    var name = ""
    var address = ""
    var phone = ""
    var url = ""
    var notes = ""
    var rating = 0.0
    
}
