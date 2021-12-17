//
//  Extension+Date.swift
//  VenueVision
//
//  Created by Invision040-Raza on 18/09/2019.
//  Copyright © 2019 Muhammad Raza. All rights reserved.
//

import Foundation

extension Date {
    func dateString(_ format: String = "MMM-dd-YYYY, hh:mm a") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current
        let calendar = Calendar.current
        if calendar.isDateInToday(self) {
            return "Today, \(dateFormatter.string(from: self))"
        } else if calendar.isDateInYesterday(self) {
            return "Yesterday, \(dateFormatter.string(from: self))"
        } else {
            let startOfNow = calendar.startOfDay(for: Date())
            let startOfTimeStamp = calendar.startOfDay(for: self)
            let components = calendar.dateComponents([.day], from: startOfNow, to: startOfTimeStamp)
            let day = components.day!
            if day < 1 {
                return "\(-day) days ago"
            }
            else {
                return "In \(day) days"
            }
//            return dateFormatter.string(from: self)
        }
    }
}

extension Date {
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        
        if secondsAgo < minute {
            return "\(secondsAgo) sec ago"
        } else if secondsAgo < hour {
            return "\(secondsAgo / minute) min ago"
        } else if secondsAgo < day {
            return "\(secondsAgo / hour) hrs ago"
        } else if secondsAgo < week {
            return "\(secondsAgo / day) days ago"
        }
        
        return "\(secondsAgo / week) weeks ago"
    }
}

extension Date{
    func toString(format:String, timezone:TimeZone = .current)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = timezone
        formatter.locale = Locale(identifier: Locale.current.identifier)
        return formatter.string(from: self)
    }
}

extension String {
    
    func toDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss")-> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current//TimeZone(abbreviation: "UTC")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date
    }
}

extension Date{
    var timeOfDay:String{
        let hour = Calendar.current.component(.hour, from: self)
        switch hour {
            case 0...5: return "Good Night"
            case 6...11 : return "Good Morning"
            case 12...17 : return "Good Afternoon"
            case 18...23 : return "Good Evening"
            default: fatalError("Unexpected time of day")
        }
    }
}
