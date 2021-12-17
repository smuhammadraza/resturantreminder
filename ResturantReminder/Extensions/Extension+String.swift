//
//  Extension+String.swift
//  VenueVision
//
//  Created by macbook on 29/01/2020.
//  Copyright © 2020 Muhammad Raza. All rights reserved.
//

import Foundation

extension String{
    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}

extension Double {
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension String {
    func htmlDecoded()->String {

        guard (self != "") else { return self }

        var newStr = self
        // from https://en.wikipedia.org/wiki/List_of_XML_and_HTML_character_entity_references
        let entities = [ //a dictionary of HTM/XML entities.
            "&quot;"    : "\"",
            "&amp;"     : "&",
            "&apos;"    : "'",
            "&lt;"      : "<",
            "&gt;"      : ">",
            "&deg;"     : "º",
            ]

        for (name,value) in entities {
            newStr = newStr.replacingOccurrences(of: name, with: value)
        }
        return newStr
    }
}
