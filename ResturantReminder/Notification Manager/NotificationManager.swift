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
            content.userInfo = ["id": identifier]

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
            let request = UNNotificationRequest(identifier: "reminder" + "\(Date().timeIntervalSince1970)", content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
//            Snackbar.showSnackbar(message: "notification will be shown for \(restaurantName)", duration: .middle)

        }
        
    }
    
    func fetchRestaurantName(restaurantID: String, completion: @escaping (String)->Void) {
        FirebaseManager.shared.fetchSingleResturant(userID: UserModel.shared.userID, resturantID: restaurantID) { (model, _) in
            if let model = model {
                completion(model.name ?? "Restaurant")
            }
        }
    }
    
    func triggerRandomNotification(identifier: String, timeInterval: Int) {
        
        let content = UNMutableNotificationContent()
        
        content.title = "Random Test Notification"
        content.body = "You're not actually near Restaurant."
        content.sound = UNNotificationSound.default
        content.badge = 1
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timeInterval), repeats: false)
        
        let request = UNNotificationRequest(identifier: "reminder" + "\(Date().timeIntervalSince1970)", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        Snackbar.showSnackbar(message: "notification will be shown after \(timeInterval) seconds", duration: .middle)
        
    }
}
