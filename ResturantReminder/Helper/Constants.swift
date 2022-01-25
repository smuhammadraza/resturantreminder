//
//  Constants.swift
//  ResturantReminder
//
//  Created by Mehdi Haider on 15/12/2021.
//

import Foundation

struct Constants {
    
    static let googleClientID = "768858567965-8mqmbbep3m10kiqo11sg5tl1ov41qa3d.apps.googleusercontent.com"
    static let googleAPIKey = "AIzaSyDV6CKIasQTeATHGMja2ky59CieBzKKSWM"
    struct Storyboards {
        static let launchScreen = "LaunchScreen"
        static let authentication = "Authentication"
        static let main = "Main"
    }
    
    struct CellIdentifiers {
        static let HomeTableViewCell = "HomeTableViewCell"
        static let HomeCollectionViewCell = "HomeCollectionViewCell"
        static let AddCategoriesCollectionViewCell = "AddCategoriesCollectionViewCell"
        static let CategoryCollectionViewCell = "CategoryCollectionViewCell"
    }
}

extension Notification.Name {
    static let dismissAddRestaurant = Notification.Name("dismissAddRestaurant")
}
