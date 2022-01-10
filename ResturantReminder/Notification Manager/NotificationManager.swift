//
//  NotificationManager.swift
//  ResturantReminder
//
//  Created by Faraz on 1/6/22.
//

import Foundation
import UserNotifications

class NotificationManager {
    
    static let shared = NotificationManager()
    private init() {}
    
    func triggerReminderNotification(identifier: String) {
        
        self.fetchRestaurantName(restaurantID: identifier) {
            restaurantName in
            //other code...
            let content = UNMutableNotificationContent()

            content.title = "Restaurant Reminder"
    //        content.subtitle = message
            content.body = "You're near \(restaurantName)."
            content.sound = UNNotificationSound.default
            content.badge = 1

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
            let request = UNNotificationRequest(identifier: "reminder", content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
        
    }
    
    func fetchRestaurantName(restaurantID: String, completion: @escaping (String)->Void) {
        FirebaseManager.shared.fetchSingleResturant(userID: UserModel.shared.userID, resturantID: restaurantID) { (model, _) in
            if let model = model {
                completion(model.name ?? "Restaurant")
            }
        }

    }
}